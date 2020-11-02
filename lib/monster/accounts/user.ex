defmodule Monster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :nickname, :string
    field :password, :string
    field :pending_email, :string

    field :password_updated_at, :naive_datetime
    field :banned, :boolean, default: false

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
      |> place_email_unverified()
  end

  def hash_new_user_password(changeset) do
    hashed = Bcrypt.hash_pwd_salt(changeset.changes.password)
    changeset |> put_change(:password, hashed)
  end

  def place_email_unverified(changeset) do
    changeset
      |> put_change(:pending_email, changeset.changes.email)
      |> put_change(:email, "")
  end
end
