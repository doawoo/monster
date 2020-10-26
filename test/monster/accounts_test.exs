defmodule Monster.AccountsTest do
  use Monster.DataCase

  alias Monster.Accounts

  describe "users" do
    alias Monster.Accounts.User

    @valid_attrs %{email: "some email", nickname: "some nickname", password: "some password"}
    @update_attrs %{email: "some updated email", nickname: "some updated nickname", password: "some updated password"}
    @invalid_attrs %{email: nil, nickname: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.nickname == "some nickname"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.nickname == "some updated nickname"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "tokens" do
    alias Monster.Accounts.Token

    @valid_attrs %{expires: ~N[2010-04-17 14:00:00], token_string: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{expires: ~N[2011-05-18 15:01:01], token_string: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{expires: nil, token_string: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Accounts.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Accounts.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Accounts.create_token(@valid_attrs)
      assert token.expires == ~N[2010-04-17 14:00:00]
      assert token.token_string == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Accounts.update_token(token, @update_attrs)
      assert token.expires == ~N[2011-05-18 15:01:01]
      assert token.token_string == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_token(token, @invalid_attrs)
      assert token == Accounts.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Accounts.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_token(token)
    end
  end
end
