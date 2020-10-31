defmodule Monster.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "character" do
    field :blurb, :string
    field :long_blurb, :string
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :blurb, :long_blurb])
    |> validate_required([:name, :blurb, :long_blurb])
  end
end
