defmodule ListappWeb.CommentController do
  use ListappWeb, :controller

  alias Listapp.Events
  alias Listapp.Events.Comment

  plug :authorize_commenter when action in [:edit, :delete, :update]

  def index(conn, %{"event_id" => event_id}) do
    comments = Events.list_event_comments(event_id)
    render(conn, "index.html", comments: comments)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Events.change_comment(%Comment{})
    render(conn, "new.html", event_id: event_id, changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params, "event_id" => event_id}) do
    event = Events.get_event!(event_id)
    case Events.create_comment(conn.assigns.current_user, event, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, event_id: event_id)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   comment = Events.get_comment!(id)
  #   render(conn, "show.html", comment: comment)
  # end

  def edit(conn, %{"id" => id, "event_id" => event_id}) do
    comment = Events.get_comment!(id)
    changeset = Events.change_comment(comment)
    render(conn, "edit.html", comment: comment, event_id: event_id, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params, "event_id" => event_id}) do
    comment = Events.get_comment!(id)
    event = Events.get_event!(event_id)
    case Events.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, event_id: event_id, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "event_id" => event_id}) do
    comment = Events.get_comment!(id)
    {:ok, _comment} = Events.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :show, event_id))
  end

  defp authorize_commenter(conn, _opts) do
    %{params: %{"id" => comment_id, "event_id" => event_id}} = conn
    comment = Events.get_comment!(comment_id)
    if conn.assigns.current_user == comment.user do
      conn
    else
      conn
      |> put_flash(:error, "You are not the owner of that comment.")
      |> redirect(to: Routes.event_path(conn, :show, event_id))
      |> halt()
    end
  end

end
