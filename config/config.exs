# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :monster,
  ecto_repos: [Monster.Repo]

# Configures the endpoint
config :monster, MonsterWeb.Endpoint,
  url: [host: System.get_env("APP_HOSTNAME")],
  secret_key_base: System.get_env("APP_KEY"),
  render_errors: [view: MonsterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Monster.PubSub,
  live_view: [signing_salt: System.get_env("APP_SIGN_SALT")]

config :monster, MonsterWeb.RealmConfig,
  realm_url: System.get_env("APP_KEYCLOAK_REALM_URL")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
