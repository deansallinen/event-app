defmodule ListappWeb.CommentView do
  use ListappWeb, :view
  use Timex

  def format_timestamp(comment_timestamp) do
    case Timex.Format.DateTime.Formatters.Relative.format(comment_timestamp, "{relative}") do
      {:ok, timestamp} -> timestamp
      {:error, error} -> error
    end
  end

  def comment_owner?(conn, comment) do
    conn.assigns.current_user.id === comment.user.id
  end

  def is_edited?(comment) do
    comment.updated_at != comment.inserted_at
  end


end
