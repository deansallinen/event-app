defmodule ListappWeb.UserController do
  use ListappWeb, :controller

  alias Listapp.Accounts
  alias Listapp.Accounts.User
  plug :authorize_user when action in [:edit, :delete, :update]
  plug :authorize_admin when action in [:index]


  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> ListappWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  # TODO: fix bug where deleting yourself doesn't clear session
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  defp authorize_user(conn, _opts) do
    %{params: %{"id" => user_id}} = conn
    user = Accounts.get_user!(user_id)
    if conn.assigns.current_user == user do
      conn
    else
      conn
      |> put_flash(:error, "You are not allowed to edit that user")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_admin(conn, _opts) do
    if conn.assigns.current_user.credential.email == "deza604@gmail.com" do
      conn
    else
      conn
      |> put_flash(:error, "You are not the admin")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
