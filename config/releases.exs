import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :kalda, Kalda.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :kalda, KaldaWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: "kalda.co", port: 80],
  secret_key_base: secret_key_base,
  server: true

# Sendfox api (email signups management)
sendfox_token =
  System.get_env("SENDFOX_TOKEN") ||
    raise """
    environment variable SENDFOX_TOKEN is missing
    """

config :kalda, :sendfox_api_token, sendfox_token

sendgrid_key =
  System.get_env("SENDGRID_API_KEY") ||
    raise """
    environment variable SENDGRID_API_KEY is missing
    """

config :kalda, Kalda.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: sendgrid_key,
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

# Rollbar for exception tracking
rollbax_token =
  System.get_env("ROLLBAR_ACCESS_TOKEN") ||
    raise """
    environment variable ROLLBAR_ACCESS_TOKEN is missing
    """

config :rollbax,
  access_token: rollbax_token,
  environment: "production",
  enable_crash_reports: true
