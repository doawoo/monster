defmodule Monster.Repo.Migrations.AddEmailValidation do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :pending_email, :text
    end
  end
end
