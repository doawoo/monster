defmodule Monster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :nickname, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset_new_user(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_length(:email, min: 2, max: 255)
    |> validate_length(:password, min: 8)
    |> validate_length(:nickname, min: 2, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> hash_new_user_password()
  end

  def hash_new_user_password(changeset) do
    hashed = Bcrypt.hash_pwd_salt(changeset.changes.password)
    changeset |> put_change(:password, hashed)
  end
end
