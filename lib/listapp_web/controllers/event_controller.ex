defmodule ListappWeb.EventController do
  use ListappWeb, :controller
  alias Phoenix.LiveView

  alias Listapp.{Events, Accounts}
  alias Listapp.Events.{Event, Item, Guest, Comment}
  plug :authorize_host when action in [:edit, :delete, :update]
  # plug :check_host

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, nil) do
    render(conn, "index_guest.html", events: [])
  end

  def index(conn, params, current_user) do
    events = 
      case params do
        %{"filter" => "hosting"} ->
          Events.list_user_hosted_events(current_user)
        %{"filter" => "attending"} ->
          Events.list_user_attended_events(current_user)
        _ ->
          Events.list_user_events(current_user) 
      end
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
  
   defp validate_referral(ref_id, event) do
     referrer = Accounts.get_user!(ref_id)
     cond do
       referrer in event.guests ->
         {:ok, referrer}
       referrer == event.host ->
         {:ok, referrer}
       true -> 
         {:error, :unauthorized}
     end
   end

  def show(conn, %{"id" => id} = params, current_user) do
    event = Events.get_event!(id)
    is_host? = current_user == event.host
    is_guest? = current_user in event.guests

    referrer = 
      case params do 
        %{"ref" => ref_id} ->
          case validate_referral(ref_id, event) do
            {:ok, referrer} -> referrer
            {:error, _message} -> nil 
          end
        _ -> nil
      end

    assigns = [
      event: event, 
      item_changeset: Events.change_item(%Item{}), 
      guest_changeset: Events.change_guest(%Guest{}),
      comment_changeset: Events.change_comment(%Comment{}),
    ]

    cond do
      referrer ->
        conn
        |> put_flash(:info, "Referred by #{referrer.name}") 
        |> render("show.html", assigns)
      is_host? || is_guest? ->
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

  # defp check_host(conn, _opts) do
  #   %{params: %{"id" => event_id}} = conn
  #   event = Events.get_event!(event_id)
  #   if conn.assigns.current_user == event.host do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You are not the host.")
  #     |> redirect(to: Routes.event_path(conn, :show, event))
  #     |> halt()
  #   end
  # end

end
