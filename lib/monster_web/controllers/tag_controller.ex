defmodule MonsterWeb.TagController do
  use MonsterWeb, :controller

  alias Monster.Characters.Character
  alias Monster.Characters.Tag

  alias MonsterWeb.Formatters.Errors

  action_fallback MonsterWeb.FallbackController

  def get_tags(%Plug.Conn{} = conn, %{"character_id" => character_id}) do
    user_id = conn.assigns.token.user_id
    character = Monster.Repo.get_by(Character, user_id: user_id, id: character_id)
    case character do
      %Character{} = found_character ->
        tags = Monster.Repo.all(Tag, character_id: found_character.id)
        conn |> json(%{
          character: found_character,
          tags: tags
        })
      nil -> conn |> put_status(:not_found) |> json(%{})
    end
  end

  @spec add_tag(Plug.Conn.t(), map) :: Plug.Conn.t()
  def add_tag(%Plug.Conn{} = conn, %{
        "character_id" => character_id,
        "tag" => %{"key" => key, "value" => value}
      }) do
    user_id = conn.assigns.token.user_id

    params = %{
      "character_id" => character_id,
      "key" => key,
      "value" => value
    }

    with %Character{} = _ <- Monster.Repo.get_by(Character, user_id: user_id, id: character_id),
         {:ok, new_tag} <- Monster.Characters.create_character(params) do
      conn |> put_status(:created) |> json(new_tag)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))
    end
  end

  @spec update_tag(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update_tag(
        %Plug.Conn{} = conn,
        %{"character_id" => character_id, "tag_id" => tag_id, "tag" => tag} = _params
      ) do
    user_id = conn.assigns.token.user_id

    # do not allow these options to exist in the patch
    new_tag_params = Map.delete(tag, "character_id")

    with %Character{} = existing_character <-
           Monster.Repo.get_by(Character, user_id: user_id, id: character_id),
         {:ok, existing_tag} <-
           Monster.Repo.get_by(Tag, character_id: existing_character.id, id: tag_id),
         {:ok, updated_tag} <- Monster.Repo.update(Tag.changeset(existing_tag, new_tag_params)) do
      conn |> json(updated_tag)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn |> put_status(:bad_request) |> json(Errors.ecto_errors(errors))

      _ ->
        conn |> put_status(:not_found) |> json(%{})
    end
  end

  @spec delete_tag(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete_tag(
        %Plug.Conn{} = conn,
        %{"character_id" => character_id, "tag_id" => tag_id} = _params
      ) do
    user_id = conn.assigns.token.user_id
    character = Monster.Repo.get_by(Character, user_id: user_id, id: character_id)

    with %Character{} = existing_character <- character,
         {:ok, existing_tag} <-
           Monster.Repo.get_by(Tag, character_id: existing_character.id, id: tag_id),
         {:ok, _deleted} <- Monster.Repo.delete(existing_tag) do
      conn |> json(%{})
    else
      _ -> conn |> put_status(:not_found) |> json(%{})
    end
  end
end
