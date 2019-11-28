defmodule Listapp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :event_id, references(:events, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing) # TODO: remove reference on delete

      timestamps()
    end

    create index(:items, [:event_id])
  end
end
