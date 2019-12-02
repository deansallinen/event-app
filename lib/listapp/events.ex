defmodule Listapp.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Listapp.Repo

  alias Listapp.Events.{Event, Item, Guest}
  alias Listapp.Accounts.User

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  def list_user_events(%User{} = user) do
    Event
    |> user_events_query(user)
    |> Repo.all()
  end

  def list_user_attended_events(%User{} = user) do
    Repo.all(Ecto.assoc(user, :attended_events))
  end

  def get_user_event!(%User{} = user, id) do
    Event
    |> user_events_query(user)
    |> Repo.get!(id)
    |> Repo.preload(items: :user)
    |> Repo.preload(:host)
    |> Repo.preload(:guests)
  end

  defp user_events_query(query, %User{id: host_id}) do
    from(e in query, where: e.host_id == ^host_id) 
  end


  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Event
    |> Repo.get!(id)
    |> Repo.preload(items: :user)
    |> Repo.preload(:host)
    |> Repo.preload(guests: :credential)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(%User{} = user, attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:host, user)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  # def add_guest(%User{} = user, %Event{} = event, attrs \\ %{}) do
  #   event 
  #   |> Repo.preload(:guests)
  #   |> Event.changeset(attrs)
  #   |> Ecto.Changeset.put_assoc(:guests, [user])
  #   |> Repo.update()
  # end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  def list_items do
    Item
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_items_in_event(event) do
    Item
    |> events_items_query(event)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_item_in_event!(%Event{} = event, id) do
    Item
    |> events_items_query(event)
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  defp events_items_query(query, event_id) do
    from(i in query, where: i.event_id == ^event_id) 
  end

  def get_item!(id) do 
    Item
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  def create_item(%User{} = user, %Event{} = event, attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:event, event)
    # |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def update_item(%Item{} = item, %User{} = user, attrs) do
    item
    # |> Repo.preload(:user)
    |> Item.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.update()
  end

  def assign_item(%Item{} = item, %User{} = user) do
    item
    |> Repo.preload(:user)
    |> Item.changeset(%{})
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  # def assign_item(%Item{} = item, attrs \\ %{}) do
  #   item
  # end

  # def list_guests do
  #   Repo.all(Guest)
  # end

  # def get_guest!(id), do: Repo.get!(Guest, id)

  def get_guest_by_user_and_event_id!(user_id, event_id) do 
    Guest
    |> where(user_id: ^user_id)
    |> where(event_id: ^event_id)
    |> Repo.one()
  end

  def create_guest(%User{} = user, %Event{} = event, attrs \\ %{}) do
    %Guest{}
    |> Guest.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:event, event)
    |> Repo.insert()
  end

  # def update_guest(%Guest{} = guest, attrs) do
  #   guest
  #   |> Guest.changeset(attrs)
  #   |> Repo.update()
  # end

  def delete_guest(%Guest{} = guest) do
    Repo.delete(guest)
  end

  def change_guest(%Guest{} = guest) do
    Guest.changeset(guest, %{})
  end
end
