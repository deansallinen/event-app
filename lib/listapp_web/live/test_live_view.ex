defmodule ListappWeb.TestLiveView do 
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>Hello from <%= @message %></div>
      <div>
    <button phx-click="inc">Increment</button>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, message: "LiveView")} 
  end


  def handle_event("inc", _value, socket) do

    {:noreply, assign(socket, message: "New Message")}
  end
end
