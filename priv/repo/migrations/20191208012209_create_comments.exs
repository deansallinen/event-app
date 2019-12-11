defmodule Listapp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :message, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:event_id])
  end
end
