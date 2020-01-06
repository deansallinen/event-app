defmodule ListappWeb.ItemController do
  use ListappWeb, :controller
  alias Phoenix.LiveView
  alias Listapp.Events

  def live(conn, _params) do
    LiveView.Controller.live_render(conn, ListappWeb.ItemsList, session: %{})
  end

  def index(conn, %{"event_id" => event_id}) do
    items = Events.list_items_in_event(event_id)
    render(conn, "index.html", items: items)
  end

  def create(conn, %{"item" => item_params, "event_id" => event_id} = _params) do
    event = Events.get_event!(event_id)

    case Events.create_item(conn.assigns.current_user, event, item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "event_id" => event_id}) do
    item = Events.get_item!(id)
    {:ok, _item} = Events.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :show, event_id))
  end

  def show(conn, %{"id" => id}) do
    item = Events.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id, "event_id" => event_id}) do
    item = Events.get_item!(id)
    event = Events.get_event!(event_id)
    changeset = Events.change_item(item)
    render(conn, "edit.html", event: event, item: item, item_changeset: changeset)
  end

  def update(conn, %{"id" => id, "event_id" => event_id, "item" => item_params}) do
    item = Events.get_item!(id)
    event = Events.get_event!(event_id)

    case Events.update_item(item, item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, item: item, item_changeset: changeset)
    end
  end

  def claim(conn, %{"id" => id, "event_id" => event_id}) do
    item = Events.get_item!(id)
    event = Events.get_event!(event_id)

    case Events.assign_item(item, conn.assigns.current_user) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item claimed successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Cannot claim")
        # render(conn, "edit.html", item: item, changeset: changeset)
        |> redirect(to: Routes.event_path(conn, :show, event))
    end
  end

end
