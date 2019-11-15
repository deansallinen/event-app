defmodule Listapp.Web.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Web.Item

  schema "events" do
    field :date, :date
    field :description, :string
    field :title, :string
    has_many :item, Item

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :date])
    |> validate_required([:title, :description, :date])
  end
end
