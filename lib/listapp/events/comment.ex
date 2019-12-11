defmodule Listapp.Events.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Accounts.User
  alias Listapp.Events.Event

  schema "comments" do
    field :message, :string
    # field :user_id, :id
    # field :event_id, :id
    belongs_to :user, User
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
