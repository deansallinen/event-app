defmodule Listapp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:event_id])
  end
end
