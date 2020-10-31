defmodule MonsterWeb.CharacterController do
  use MonsterWeb, :controller

  alias Monster.Characters
  alias Monster.Characters.Character

  action_fallback MonsterWeb.FallbackController

  def index(conn, _params) do
  end

  def create(conn, %{"character" => character_params}) do
  end

  def show(conn, %{"id" => id}) do
  end

  def update(conn, %{"id" => id, "character" => character_params}) do
  end

  def delete(conn, %{"id" => id}) do
  end
end
