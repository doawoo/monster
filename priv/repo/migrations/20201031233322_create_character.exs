defmodule Monster.Repo.Migrations.CreateCharacter do
  use Ecto.Migration

  def change do
    create table(:character) do
      add :name, :text
      add :blurb, :text
      add :long_blurb, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:character, [:user_id])
  end
end
