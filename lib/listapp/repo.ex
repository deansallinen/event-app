defmodule Listapp.Repo do
  use Ecto.Repo,
    otp_app: :listapp,
    adapter: Ecto.Adapters.Postgres
end
