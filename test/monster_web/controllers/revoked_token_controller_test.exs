defmodule MonsterWeb.RevokedTokenControllerTest do
  use MonsterWeb.ConnCase

  alias Monster.Tokens
  alias Monster.Tokens.RevokedToken

  @create_attrs %{
    token_string: "some token_string"
  }
  @update_attrs %{
    token_string: "some updated token_string"
  }
  @invalid_attrs %{token_string: nil}

  def fixture(:revoked_token) do
    {:ok, revoked_token} = Tokens.create_revoked_token(@create_attrs)
    revoked_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all revoked_tokens", %{conn: conn} do
      conn = get(conn, Routes.revoked_token_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create revoked_token" do
    test "renders revoked_token when data is valid", %{conn: conn} do
      conn = post(conn, Routes.revoked_token_path(conn, :create), revoked_token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.revoked_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "token_string" => "some token_string"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.revoked_token_path(conn, :create), revoked_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update revoked_token" do
    setup [:create_revoked_token]

    test "renders revoked_token when data is valid", %{conn: conn, revoked_token: %RevokedToken{id: id} = revoked_token} do
      conn = put(conn, Routes.revoked_token_path(conn, :update, revoked_token), revoked_token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.revoked_token_path(conn, :show, id))

      assert %{
               "id" => id,
               "token_string" => "some updated token_string"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, revoked_token: revoked_token} do
      conn = put(conn, Routes.revoked_token_path(conn, :update, revoked_token), revoked_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete revoked_token" do
    setup [:create_revoked_token]

    test "deletes chosen revoked_token", %{conn: conn, revoked_token: revoked_token} do
      conn = delete(conn, Routes.revoked_token_path(conn, :delete, revoked_token))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.revoked_token_path(conn, :show, revoked_token))
      end
    end
  end

  defp create_revoked_token(_) do
    revoked_token = fixture(:revoked_token)
    %{revoked_token: revoked_token}
  end
end
