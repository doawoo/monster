defmodule Monster.CharactersTest do
  use Monster.DataCase

  alias Monster.Characters

  describe "character" do
    alias Monster.Characters.Character

    @valid_attrs %{blurb: "some blurb", long_blurb: "some long_blurb", name: "some name"}
    @update_attrs %{blurb: "some updated blurb", long_blurb: "some updated long_blurb", name: "some updated name"}
    @invalid_attrs %{blurb: nil, long_blurb: nil, name: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_character()

      character
    end

    test "list_character/0 returns all character" do
      character = character_fixture()
      assert Characters.list_character() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Characters.create_character(@valid_attrs)
      assert character.blurb == "some blurb"
      assert character.long_blurb == "some long_blurb"
      assert character.name == "some name"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, %Character{} = character} = Characters.update_character(character, @update_attrs)
      assert character.blurb == "some updated blurb"
      assert character.long_blurb == "some updated long_blurb"
      assert character.name == "some updated name"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_character(character, @invalid_attrs)
      assert character == Characters.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Characters.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Characters.change_character(character)
    end
  end

  describe "tag" do
    alias Monster.Characters.Tag

    @valid_attrs %{key: "some key", value: "some value"}
    @update_attrs %{key: "some updated key", value: "some updated value"}
    @invalid_attrs %{key: nil, value: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_tag()

      tag
    end

    test "list_tag/0 returns all tag" do
      tag = tag_fixture()
      assert Characters.list_tag() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Characters.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Characters.create_tag(@valid_attrs)
      assert tag.key == "some key"
      assert tag.value == "some value"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Characters.update_tag(tag, @update_attrs)
      assert tag.key == "some updated key"
      assert tag.value == "some updated value"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_tag(tag, @invalid_attrs)
      assert tag == Characters.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Characters.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Characters.change_tag(tag)
    end
  end
end
