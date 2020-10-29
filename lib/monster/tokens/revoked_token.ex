defmodule Monster.Tokens.RevokedToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revoked_tokens" do
    field :token_string, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(revoked_token, attrs) do
    revoked_token
    |> cast(attrs, [:token_string, :user_id])
    |> unique_constraint(:token_string)
    |> validate_required([:token_string, :user_id])
  end
end
