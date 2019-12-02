defmodule Listapp.Events.Guest do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Listapp.Accounts.User
  alias Listapp.Events.Event

  schema "guests" do
    belongs_to :user, User
    belongs_to :event, Event
    # field :user_id, :id
    # field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:user_id, :event_id])
    |> validate_required([])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
  end
end
