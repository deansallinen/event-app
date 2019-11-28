defmodule Listapp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Listapp.Accounts.Credential
  alias Listapp.Events.Event

  schema "users" do
    field :name, :string
    field :username, :string

    has_one :credential, Credential
    has_many :events, Event # Host
    # many_to_many :events, Event # Guest

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

end
