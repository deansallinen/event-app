# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :listapp,
  ecto_repos: [Listapp.Repo]

# Configures the endpoint
config :listapp, ListappWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mkLRa0/RoZFrC+1qaQ1Eo4bcsw7TPJmWNYCE9VHSdMkzAmWKO7XlaAY9hBnxMUdm",
  render_errors: [view: ListappWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Listapp.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "eLWq3hwpkzCXbX7YlH/FMphuWLGwnSmlIb3eZ/ShWFOVidU2uxQp618AlsaQjEgQ"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
