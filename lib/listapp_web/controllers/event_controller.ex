defmodule ListappWeb.EventController do
  use ListappWeb, :controller

  alias Listapp.Events
  alias Listapp.Events.{Event, Item, Guest}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    hosted_events = Events.list_user_events(current_user)
    attended_events = Events.list_user_attended_events(current_user)
    render(
      conn, 
      "index.html", 
      events: hosted_events, 
      attended_events: attended_events
    )
  end

  def new(conn, _params, _current_user) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}, current_user) do
    case Events.create_event(current_user, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    # event = Events.get_user_event!(current_user, id)
    event = Events.get_event!(id)
    item_changeset = Events.change_item(%Item{})
    guest_changeset = Events.change_guest(%Guest{})

    cond do
      current_user in event.guests ->
        render(
          conn, 
          "show.html", 
          event: event, 
          item_changeset: item_changeset,
          guest_changeset: guest_changeset
        )
      current_user ->
        render(
          conn, 
          "rsvp.html", 
          event: event, 
          item_changeset: item_changeset,
          guest_changeset: guest_changeset
        )
      true ->
        render(conn, "show_guest.html", event: event)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    event = Events.get_user_event!(current_user, id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}, current_user) do
    event = Events.get_user_event!(current_user, id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    event = Events.get_user_event!(current_user, id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
