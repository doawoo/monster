defmodule Monster.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :expires, :naive_datetime
      add :token_string, :text
      add :revoked, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tokens, [:user_id])
    create index(:tokens, [:token_string])
  end
end
