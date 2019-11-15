defmodule Listapp.Web.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Web.Event

  schema "items" do
    field :name, :string
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
