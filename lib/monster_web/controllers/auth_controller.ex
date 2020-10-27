defmodule MonsterWeb.AuthController do
  use MonsterWeb, :controller

  alias MonsterWeb.Formatters.Errors
  alias Monster.Accounts.User


  def register(conn, %{"user" => %{"email" => _email, "password" => password, "nickname" => _nickname} = params}) do
    with {:ok, _password} <- NotQwerty123.PasswordStrength.strong_password?(password),
      %Ecto.Changeset{valid?: true} = changeset <- User.changeset_new_user(%User{}, params),
      {:ok, _new_user} <- Monster.Repo.insert(changeset) do
      conn |> put_status(:created) |> json(%{status: 201, message: "created"})
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
    json(conn, %{})
  end
  def login(conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))

  def logout(conn, _) do
    json(conn, %{})
  end
end
