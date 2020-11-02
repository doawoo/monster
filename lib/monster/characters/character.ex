defmodule Monster.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :blurb, :long_blurb, :user_id, :id]}

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
    |> cast(attrs, [:name, :blurb, :long_blurb, :user_id])
    |> validate_length(:name, min: 0, max: 256)
    |> validate_length(:blurb, min: 0, max: 256)
    |> validate_required([:name, :blurb, :long_blurb, :user_id])
  end
end
