defmodule ListappWeb.SessionController do
  use ListappWeb, :controller

  alias Listapp.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do

    redirect_to = 
      case conn.params["redirect"] do
        nil -> 
          Routes.event_path(conn, :index)
        path ->
          path
      end
    
    case Accounts.authenticate_by_username_and_password(username, password) do
      {:ok, user} ->
        conn
        |> ListappWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: redirect_to)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ListappWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
