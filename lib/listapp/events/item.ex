defmodule Listapp.Events.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Events.Event
  alias Listapp.Accounts.User

  schema "items" do
    field :name, :string

    belongs_to :event, Event
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :event_id, :user_id])
    |> validate_required([:name])
  end

  def assign_changeset(item, attrs) do
    item
    |> cast(attrs, [:user_id])
  end

end
