defmodule ListappWeb.EventController do
  use ListappWeb, :controller
  alias Phoenix.LiveView

  alias Listapp.Events
  alias Listapp.Events.{Event, Item, Guest}
  plug :authorize_host when action in [:edit, :delete, :update]

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  # def index(conn, _params, current_user) do
  #   events = Events.list_user_events(current_user)
  #   hosted_events = Events.list_user_hosted_events(current_user)
  #   attended_events = Events.list_user_attended_events(current_user)
  #   LiveView.Controller.live_render(conn, ListappWeb.EventIndex, session: %{
  #     hosted_events: hosted_events, 
  #     events: events, 
  #     attended_events: attended_events
  #   })
  # end

  def index(conn, %{"filter" => "hosting"}, current_user) do
    hosted_events = Events.list_user_hosted_events(current_user)
    render(conn, "index.html", events: hosted_events)
  end
  def index(conn, %{"filter" => "attending"}, current_user) do
    attended_events = Events.list_user_attended_events(current_user)
    render(conn, "index.html", events: attended_events)
  end
  def index(conn, _params, nil) do
    render(conn, "index_guest.html", events: [])
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

  def show(conn, %{"id" => id, "ref" => referral}, current_user) do
    event = Events.get_event!(id)
    # Check valid referral
    ref_valid? = true

    cond do
      ref_valid? ->
        show(conn, %{"id" => id}, current_user || :referral)
      true -> 
        conn
        |> put_view(ListappWeb.ErrorView)
        |> render("404.html")
        |> halt()
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    event = Events.get_event!(id)
    item_changeset = Events.change_item(%Item{})
    guest_changeset = Events.change_guest(%Guest{})

    assigns = [
      event: event, 
      item_changeset: item_changeset, 
      guest_changeset: guest_changeset,
      is_host: false,
    ]
    
    cond do
      current_user == event.host ->
        render(conn, "show.html", Keyword.put(assigns, :is_host, true))
      current_user in event.guests || current_user == :referral->
        render(conn, "show.html", assigns)
      true ->
        conn
        |> put_view(ListappWeb.ErrorView)
        |> render("404.html")
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

  defp authorize_host(conn, _opts) do
    %{params: %{"id" => event_id}} = conn
    event = Events.get_event!(event_id)
    if conn.assigns.current_user == event.host do
      conn
    else
      conn
      |> put_flash(:error, "You are not the host.")
      |> redirect(to: Routes.event_path(conn, :show, event))
      |> halt()
    end
  end
end
