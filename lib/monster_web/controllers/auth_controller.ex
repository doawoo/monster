defmodule MonsterWeb.AuthController do
  use MonsterWeb, :controller

  alias MonsterWeb.Formatters.Errors
  alias Monster.Accounts.User
  alias Monster.Accounts

  @token_salt "USER_AUTH_TOKEN"
  @fingerprint_len 256
  @days_valid 1

  @spec register(Plug.Conn.t(), any) :: Plug.Conn.t()
  def register(%Plug.Conn{} = conn, %{"user" => %{"email" => _email, "password" => password, "nickname" => _nickname} = params}) do
    with {:ok, _password} <- NotQwerty123.PasswordStrength.strong_password?(password),
    {:ok, _new_user} <- Accounts.create_user(params) do
      conn |> put_status(:created) |> json(%{status: 201, message: "user created"})
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))
      {:error, message} ->
        conn |> put_status(:bad_request) |> json(Errors.bad_request(message))
      %Ecto.Changeset{errors: errors} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))
    end
  end
  def register(%Plug.Conn{} = conn, _), do: conn |> put_status(:bad_request) |> json(Errors.bad_request("Invalid user parameters."))

  @spec login(Plug.Conn.t(), any) :: Plug.Conn.t()
  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with %User{} = user <- Accounts.get_user_by_email(email),
    true <- Bcrypt.verify_pass(password, user.password) do
      # create a new token and return it to the user
      rand = :crypto.strong_rand_bytes(@fingerprint_len) |> Base.encode64 |> binary_part(0, @fingerprint_len)
      expr = NaiveDateTime.add(NaiveDateTime.utc_now(), 86400 * @days_valid, :second) |> NaiveDateTime.truncate(:second)
      token = Phoenix.Token.sign(MonsterWeb.Endpoint, @token_salt, %{user_id: user.id, expires: expr, fingerprint: rand})
      conn |> put_status(:ok) |> json(%{token: token})
    else
      _ -> conn |> put_status(:bad_request) |> json(Errors.bad_request("Could not authenticate"))
    end
  end
  def login(%Plug.Conn{} = conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))

  @spec revoke_token(Plug.Conn.t(), any) :: Plug.Conn.t()
  def revoke_token(%Plug.Conn{} = conn, _) do
    token_session = conn.assigns[:token]

    token_string = conn.assigns[:token_string]
    user_id = token_session.user_id

    Monster.Tokens.create_revoked_token(%{
      user_id: user_id,
      token_string: token_string
    })

    conn |> put_status(:ok) |> json(%{})
  end
end
