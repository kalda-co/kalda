# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kalda,
  ecto_repos: [Kalda.Repo]

# Configures the endpoint
config :kalda, KaldaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IxbdwQE5VMUKzcZHmqMI2CWhwt2CkKEDLNx792EjMWOELB1jmWwnZPLBdpzufBUH",
  render_errors: [view: KaldaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kalda.PubSub,
  live_view: [signing_salt: "txtn+aBP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  backends: [:console, Sentry.LoggerBackend]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Sentry for exception tracking in Production
config :sentry,
  dsn: "https://67cd9caf0b384a50aa46775b36d6517a@o523474.ingest.sentry.io/5635561",
  included_environments: [:prod],
  environment_name: Mix.env()

config :rollbax,
  access_token: "madeuptoken12345",
  # config_callback: {KaldaConfig, :rollback_config},
  environment: "production",
  enable_crash_reports: true

# defmodule KaldaConfig do
#   def rollback_config(config) do
#     Keyword.put(config, :access_token, System.get_env("ROLLBAR_ACCESS_TOKEN"))
#   end
# end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
