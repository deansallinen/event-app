defmodule ListappWeb.ItemView do
  use ListappWeb, :view

  def user_select_options(users) do
    Enum.map(users, fn user -> {user.name, user.id} end) 
  end
end
