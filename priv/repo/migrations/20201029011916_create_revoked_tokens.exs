defmodule Monster.Repo.Migrations.CreateRevokedTokens do
  use Ecto.Migration

  def change do
    create table(:revoked_tokens) do
      add :token_string, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:revoked_tokens, [:user_id])
    create index(:revoked_tokens, [:token_string])
  end
end
