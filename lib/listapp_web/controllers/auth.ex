defmodule ListappWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias ListappWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Listapp.Accounts.get_user!(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do 
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      IO.inspect conn.request_path
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> put_session(:redirect_to, conn.request_path)
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  # def authenticate_host(conn, _opts) do
  #   if conn.assigns.current_user do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You must be logged in to access that page")
  #     |> redirect(to: Routes.session_path(conn, :new))
  #     |> halt()
  #   end
  # end

  # def authenticate_admin(conn, _opts) do
  #   if conn.assigns.current_user.email == "deza604@gmail.com" do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You must be an admin to do that.")
  #     |> redirect(to: Routes.session_path(conn, :new))
  #     |> halt()
  #   end
  # end


end

