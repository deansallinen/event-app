defmodule ListappWeb.EventIndex do 
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(ListappWeb.EventView, "live.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, events: session.events)} 
  end


  def handle_event("all", _value, socket) do
    # {:noreply, assign(socket, events: session.events)}
  end
end


