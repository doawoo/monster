defmodule Monster.TokensTest do
  use Monster.DataCase

  alias Monster.Tokens

  describe "revoked_tokens" do
    alias Monster.Tokens.RevokedToken

    @valid_attrs %{token_string: "some token_string"}
    @update_attrs %{token_string: "some updated token_string"}
    @invalid_attrs %{token_string: nil}

    def revoked_token_fixture(attrs \\ %{}) do
      {:ok, revoked_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tokens.create_revoked_token()

      revoked_token
    end

    test "list_revoked_tokens/0 returns all revoked_tokens" do
      revoked_token = revoked_token_fixture()
      assert Tokens.list_revoked_tokens() == [revoked_token]
    end

    test "get_revoked_token!/1 returns the revoked_token with given id" do
      revoked_token = revoked_token_fixture()
      assert Tokens.get_revoked_token!(revoked_token.id) == revoked_token
    end

    test "create_revoked_token/1 with valid data creates a revoked_token" do
      assert {:ok, %RevokedToken{} = revoked_token} = Tokens.create_revoked_token(@valid_attrs)
      assert revoked_token.token_string == "some token_string"
    end

    test "create_revoked_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_revoked_token(@invalid_attrs)
    end

    test "update_revoked_token/2 with valid data updates the revoked_token" do
      revoked_token = revoked_token_fixture()
      assert {:ok, %RevokedToken{} = revoked_token} = Tokens.update_revoked_token(revoked_token, @update_attrs)
      assert revoked_token.token_string == "some updated token_string"
    end

    test "update_revoked_token/2 with invalid data returns error changeset" do
      revoked_token = revoked_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Tokens.update_revoked_token(revoked_token, @invalid_attrs)
      assert revoked_token == Tokens.get_revoked_token!(revoked_token.id)
    end

    test "delete_revoked_token/1 deletes the revoked_token" do
      revoked_token = revoked_token_fixture()
      assert {:ok, %RevokedToken{}} = Tokens.delete_revoked_token(revoked_token)
      assert_raise Ecto.NoResultsError, fn -> Tokens.get_revoked_token!(revoked_token.id) end
    end

    test "change_revoked_token/1 returns a revoked_token changeset" do
      revoked_token = revoked_token_fixture()
      assert %Ecto.Changeset{} = Tokens.change_revoked_token(revoked_token)
    end
  end
end
