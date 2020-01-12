defmodule Listapp.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Listapp.Repo

  alias Listapp.Events.{Event, Item, Guest, Comment}
  alias Listapp.Accounts.User

  # def list_events do
  #   Repo.all(Event)
  # end

  def list_user_events(%User{} = user) do
    created_events = Ecto.assoc(user, :created_events)
    attended_events = Ecto.assoc(user, :attended_events)
    union_query = attended_events |> union(^created_events)

    union_query
    |> subquery()
    |> order_by([asc: :start_date])
    |> Repo.all()
  end

  def list_user_attended_events(%User{} = user) do
    user
    |> Ecto.assoc(:attended_events)
    |> order_by([asc: :start_date])
    |> Repo.all()
    # Repo.all(Ecto.assoc(user, :attended_events))
  end

  def list_user_hosted_events(%User{} = user) do
    Event
    |> user_events_query(user)
    |> order_by([asc: :start_date])
    |> Repo.all()
  end

  def get_user_event!(%User{} = user, id) do
    Event
    |> user_events_query(user)
    |> Repo.get!(id)
    |> Repo.preload(items: :user)
    |> Repo.preload(:host)
    |> Repo.preload(:guests)
    |> Repo.preload(comments: :user)
  end

  defp user_events_query(events, %User{id: host_id}) do
    from(e in events, where: e.host_id == ^host_id, order_by: [asc: :start_date]) 
  end


  def get_event!(id) do
    comments_query = 
      from c in Comment, 
      join: u in assoc(c, :user), 
      order_by: [desc: c.inserted_at], 
      preload: [user: u]
    Event
    |> Repo.get!(id)
    |> Repo.preload(items: :user)
    |> Repo.preload(host: :credential)
    |> Repo.preload(guests: :credential)
    |> Repo.preload(comments: comments_query)
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
  def change_item(%Item{} = item, params) do
    Item.changeset(item, params)
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

  def list_comments do
    Repo.all(Comment)
  end

  def list_event_comments(event_id) do
    Comment
    |> where(event_id: ^event_id)
    |> order_by([asc: :inserted_at])
    |> Repo.all()
  end

  def get_comment!(id) do 
    Comment
    |> Repo.get!(id)
    |> Repo.preload(user: :credential)
  end

  def create_comment(user, event, attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:event, event)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
