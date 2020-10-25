defmodule MonsterWeb.DefaultController do
  use MonsterWeb, :controller

  def index(conn, _params) do
    json(conn, %{})
  end
end
