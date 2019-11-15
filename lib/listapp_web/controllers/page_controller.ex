defmodule ListappWeb.PageController do
  use ListappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
