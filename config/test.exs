use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kalda, Kalda.Repo,
  username: "postgres",
  password: "postgres",
  database: "kalda_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kalda, KaldaWeb.Endpoint,
  http: [port: 4002],
  server: false

config :kalda,
  sendfox_waitlist_id: "0",
  sendfox_freemium_id: "0",
  spa_static_prefix: "http://example.com/assets"

# Print only warnings and errors during test
config :logger, level: :info
config :logger, :console, level: :warning

# Bamboo email sending
config :kalda, Kalda.Mailer, adapter: Bamboo.TestAdapter
