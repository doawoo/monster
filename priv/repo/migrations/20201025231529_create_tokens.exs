defmodule Monster.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :expires, :naive_datetime
      add :token_string, :uuid
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tokens, [:user_id])
  end
end
