defmodule ListappWeb.EventController do
  use ListappWeb, :controller

  alias Listapp.Events
  alias Listapp.Events.{Event, Item}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    events = Events.list_user_events(current_user)
    render(conn, "index.html", events: events)
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
    event = Events.get_user_event!(current_user, id)
    item_changeset = Events.change_item(%Item{})
    render(conn, "show.html", event: event, item_changeset: item_changeset)
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
