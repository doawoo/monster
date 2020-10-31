defmodule MonsterWeb.TagControllerTest do
  use MonsterWeb.ConnCase

  alias Monster.Characters
  alias Monster.Characters.Tag

  @create_attrs %{
    key: "some key",
    value: "some value"
  }
  @update_attrs %{
    key: "some updated key",
    value: "some updated value"
  }
  @invalid_attrs %{key: nil, value: nil}

  def fixture(:tag) do
    {:ok, tag} = Characters.create_tag(@create_attrs)
    tag
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tag", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tag" do
    test "renders tag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "key" => "some key",
               "value" => "some value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tag" do
    setup [:create_tag]

    test "renders tag when data is valid", %{conn: conn, tag: %Tag{id: id} = tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "key" => "some updated key",
               "value" => "some updated value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag} do
      conn = delete(conn, Routes.tag_path(conn, :delete, tag))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_path(conn, :show, tag))
      end
    end
  end

  defp create_tag(_) do
    tag = fixture(:tag)
    %{tag: tag}
  end
end
