defmodule Monster.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @days_valid 1
  @token_length 1024

  schema "tokens" do
    field :expires, :naive_datetime
    field :token_string, :string
    field :revoked, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset_new_token(token, attrs) do
    token
    |> cast(attrs, [:user_id])
    |> generate_token()
    |> set_expiration()
    |> unique_constraint(:token_string)
    |> validate_required([:expires, :token_string, :user_id])
  end

  def generate_token(changeset) do
    token = :crypto.strong_rand_bytes(@token_length) |> Base.encode64 |> binary_part(0, @token_length)
    changeset |> put_change(:token_string, token)
  end

  def set_expiration(changeset) do
    expr = NaiveDateTime.add(NaiveDateTime.utc_now(), 86400 * @days_valid, :second) |> NaiveDateTime.truncate(:second)
    changeset |> put_change(:expires, expr)
  end
end
