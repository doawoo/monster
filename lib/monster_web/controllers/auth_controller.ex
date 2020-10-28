defmodule MonsterWeb.AuthController do
  use MonsterWeb, :controller

  alias MonsterWeb.Formatters.Errors
  alias Monster.Accounts.User
  alias Monster.Accounts.Token
  alias Monster.Accounts


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
      case Accounts.create_token(%{user_id: user.id}) do
        {:ok, %Token{} = token} -> conn |> put_status(:ok) |> json(%{
          "token" => token.token_string,
          "expires" => token.expires,
        })
        _ -> conn |> put_status(:internal_server_error) |> json(Errors.server_error("Something went wrong"))
      end
    else
      _ -> conn |> put_status(:bad_request) |> json(Errors.bad_request("Could not authenticate"))
    end
  end
  def login(conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))
end
