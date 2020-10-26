defmodule Monster.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :expires, :naive_datetime
    field :token_string, Ecto.UUID
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset_new_token(token, attrs) do
    token
    |> cast(attrs, [:expires, :token_string])
    |> validate_required([:expires, :token_string])
  end
end
