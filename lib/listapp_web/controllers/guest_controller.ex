defmodule ListappWeb.GuestController do
  use ListappWeb, :controller

  alias Listapp.Events
  alias Listapp.Events.Guest

  # def index(conn, _params) do
  #   guests = Events.list_guests()
  #   render(conn, "index.html", guests: guests)
  # end

  def new(conn, %{"event" => event}) do
    changeset = Events.change_guest(%Guest{})
    render(conn, "new.html", event: event, changeset: changeset)
  end

  def create(conn, %{"event_id" => event_id}) do
    event = Events.get_event!(event_id) 
    case Events.create_guest(conn.assigns.current_user, event) do
      {:ok, _guest} ->
        conn
        |> put_flash(:info, "Guest created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", event: event, changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   guest = Events.get_guest!(id)
  #   render(conn, "show.html", guest: guest)
  # end

  # def edit(conn, %{"id" => id}) do
  #   guest = Events.get_guest!(id)
  #   changeset = Events.change_guest(guest)
  #   render(conn, "edit.html", guest: guest, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "guest" => guest_params}) do
  #   guest = Events.get_guest!(id)

  #   case Events.update_guest(guest, guest_params) do
  #     {:ok, guest} ->
  #       conn
  #       |> put_flash(:info, "Guest updated successfully.")
  #       |> redirect(to: Routes.guest_path(conn, :show, guest))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", guest: guest, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"event_id" => event_id, "id" => user_id}) do
    guest = Events.get_guest_by_user_and_event_id!(user_id, event_id)
    # event = Events.get_event!(event_id)
    
    # {:ok, _guest} = Events.delete_event_guest(event_id, user_id)
    {:ok, _guest} = Events.delete_guest(guest)

    conn
    |> put_flash(:info, "Guest removed successfully.")
    |> redirect(to: Routes.event_path(conn, :show, event_id))
  end
end
