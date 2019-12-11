defmodule ListappWeb.SessionController do
  use ListappWeb, :controller

  alias Listapp.Accounts

  def new(conn, params) do

    redirect_to = params["redirect_to"] || nil

    conn = put_session(conn, :redirect_to, redirect_to)

    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}} = params) do

    IO.inspect conn

    redirect_link = 
      case get_session(conn, :redirect_to) do
        nil ->
          Routes.event_path(conn, :index)
        redirect_to -> 
          redirect_to 
      end

    case Accounts.authenticate_by_username_and_password(username, password) do
      {:ok, user} ->
        conn
        |> ListappWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> delete_session(:redirect_to)
        |> redirect(to: redirect_link) 

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
