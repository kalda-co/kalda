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
  backends: [:console]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :rollbax,
  enabled: false,
  environment: "dev"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
