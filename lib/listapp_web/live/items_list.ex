defmodule ListappWeb.ItemsList do 
  use Phoenix.LiveView
  alias Listapp.Events
  alias Listapp.Events.Item

  def render(assigns) do
    Phoenix.View.render(ListappWeb.ItemView, "live.html", assigns)
  end

  def mount(_session, socket) do
    items = Events.list_items() 
    changeset = Listapp.Events.change_item(%Item{})
    {:ok, assign(socket, items: items, changeset: changeset)} 
  end

  def handle_event("validate", %{"item" => params}, socket) do
    changeset = 
      %Item{}
      |> Events.change_item(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"item" => params}, socket) do
    # event = 
    #   user = 
    # case Events.create_item(user, event, params) do 
    #   {:ok, item} -> 
    #     {:stop, 
    #       socket |> put_flash(:info, "Item created")}
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end      
    {:noreply, assign(socket, items: socket.assigns.items ++ [params])}
  end
end
