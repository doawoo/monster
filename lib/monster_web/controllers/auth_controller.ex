defmodule MonsterWeb.AuthController do
  use MonsterWeb, :controller

  alias MonsterWeb.Formatters.Errors

  def register(conn, %{"user" => %{"email" => email, "password" => password, "nickname" => nickname}}) do
    json(conn, %{})
  end
  def register(conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    json(conn, %{})
  end
  def login(conn, _), do: conn |> json(Errors.bad_request("Invalid user parameters."))

  def logout(conn, _) do
    json(conn, %{})
  end

  defp check_password_requirements(password_string) do
    cond do
      length(password_string) < 8 -> {:error, "You password must be at least 8 characters"}
    end
  end
end
