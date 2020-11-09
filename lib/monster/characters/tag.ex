defmodule Monster.Characters.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:key, :value, :id]}

  schema "tag" do
    field :key, :string
    field :value, :string
    field :character_id, :id

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:key, :value, :character_id])
    |> validate_required([:key, :value, :character_id])
  end
end
