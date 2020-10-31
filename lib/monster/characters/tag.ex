defmodule Monster.Characters.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag" do
    field :key, :string
    field :value, :string
    field :character_id, :id

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
