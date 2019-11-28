defmodule Listapp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Events.Item
  alias Listapp.Accounts.User

  schema "events" do
    field :date, :date
    field :description, :string
    field :location, :string
    field :name, :string

    has_many :items, Item
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :location, :date])
    |> validate_required([:name, :description, :location, :date])
  end
end
