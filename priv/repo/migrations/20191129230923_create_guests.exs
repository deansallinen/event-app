defmodule Listapp.Repo.Migrations.CreateGuests do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :user_id, references(:users, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:guests, [:user_id])
    create index(:guests, [:event_id])
    create unique_index(:guests, [:event_id, :user_id])
  end
end
