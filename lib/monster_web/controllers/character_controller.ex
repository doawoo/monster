defmodule MonsterWeb.CharacterController do
  use MonsterWeb, :controller

  alias Monster.Characters
  alias Monster.Characters.Character
  alias MonsterWeb.Formatters.Errors

  action_fallback MonsterWeb.FallbackController

  def index(%Plug.Conn{} = conn, _params) do
    user_id = conn.assigns.token.user_id
    characters = Monster.Repo.all(Character, user_id: user_id)
    conn |> json(%{
      characters: characters || []
    })
  end

  def create(conn, %{"character" => character_params}) do
    user_id = conn.assigns.token.user_id
    params = Map.put_new(character_params, "user_id", user_id)

    with {:ok, new_character} <- Characters.create_character(params) do
      conn |> put_status(:created) |> json(new_character)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))
    end
  end

  def get(conn, %{"id" => id}) do
    user_id = conn.assigns.token.user_id
    case Monster.Repo.get_by(Character, user_id: user_id, id: id) do
      nil -> conn |> put_status(:not_found) |> json(%{})
      character -> conn |> json(character)
    end
  end

  def update(conn, %{"id" => id, "character" => new_character_params}) do
    user_id = conn.assigns.token.user_id

    # do not allow these options to exist in the patch
    new_character_params = new_character_params
      |> Map.delete("user_id")
      |> Map.delete("id")

    with %Character{} = existing <- Monster.Repo.get_by(Character, user_id: user_id, id: id),
    {:ok, updated_character} <- Monster.Repo.update(Character.changeset(existing, new_character_params)) do
      conn |> json(updated_character)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))
      _ -> conn |> put_status(:not_found) |> json(%{})
    end
  end

  def delete(%Plug.Conn{} = conn, %{"id" => id}) do
    user_id = conn.assigns.token.user_id
    character = Monster.Repo.get_by(Character, user_id: user_id, id: id)

    with %Character{} = character <- character,
      {:ok, _deleted} <- Monster.Repo.delete(character) do
      conn |> json(%{})
    else
      _ -> conn |> put_status(:not_found) |> json(%{})
    end
  end
end
