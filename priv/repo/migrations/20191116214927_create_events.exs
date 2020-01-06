defmodule Listapp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :text
      add :location, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime

      add :host_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
