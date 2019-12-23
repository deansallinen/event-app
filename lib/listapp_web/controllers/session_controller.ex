defmodule ListappWeb.SessionController do
  use ListappWeb, :controller

  alias Listapp.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}} = params) do

    redirect_link = 
      case get_session(conn, :redirect_to) do
        nil ->
          Routes.event_path(conn, :index)
        redirect_to -> 
          redirect_to 
      end

    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> ListappWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> delete_session(:redirect_to)
        |> redirect(to: redirect_link) 

      {:error, reason} ->
        conn
        # |> put_flash(:error, "Invalid email/password combination")
        |> put_flash(:error, "#{reason}")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ListappWeb.Auth.logout()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
