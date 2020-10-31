defmodule MonsterWeb.TagController do
  use MonsterWeb, :controller

  alias Monster.Characters
  alias Monster.Characters.Tag

  action_fallback MonsterWeb.FallbackController

  def index(conn, _params) do
  end

  def create(conn, %{"tag" => tag_params}) do
  end

  def show(conn, %{"id" => id}) do
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
  end

  def delete(conn, %{"id" => id}) do
  end
end
