defmodule ListappWeb.PageController do
  use ListappWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    # LiveView.Controller.live_render(conn, ListappWeb.TestLiveView, session: %{})
    render(conn, "index.html")
  end
end
