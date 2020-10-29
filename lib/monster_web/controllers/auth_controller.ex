defmodule MonsterWeb.AuthController do
  use MonsterWeb, :controller

  alias MonsterWeb.Formatters.Errors
  alias Monster.Accounts.User
  alias Monster.Accounts.Token
  alias Monster.Accounts

  @token_salt "USER_AUTH_TOKEN"
  @days_valid 1

  def register(conn, %{"user" => %{"email" => _email, "password" => password, "nickname" => _nickname} = params}) do
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
  def register(conn, _), do: conn |> put_status(:bad_request) |> json(Errors.bad_request("Invalid user parameters."))

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with %User{} = user <- Accounts.get_user_by_email(email),
    true <- Bcrypt.verify_pass(password, user.password) do
      # create a new token and return it to the user
      expr = NaiveDateTime.add(NaiveDateTime.utc_now(), 86400 * @days_valid, :second) |> NaiveDateTime.truncate(:second)
      token = Phoenix.Token.sign(MonsterWeb.Endpoint, @token_salt, %{user_id: user.id, expires: expr})
      conn |> put_status(:ok) |> json(%{token: token})
    else
      _ -> conn |> put_status(:bad_request) |> json(Errors.bad_request("Could not authenticate"))
    end
  end
  def login(conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))
end
