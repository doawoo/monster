defmodule Monster.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tag) do
      add :key, :text
      add :value, :text
      add :character_id, references(:character, on_delete: :nothing)

      timestamps()
    end

    create index(:tag, [:character_id])
  end
end
