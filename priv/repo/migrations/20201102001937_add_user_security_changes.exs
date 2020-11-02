defmodule Monster.Repo.Migrations.AddUserSecurityChanges do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_updated_at, :naive_datetime
      add :banned, :boolean, default: false
    end
  end
end
