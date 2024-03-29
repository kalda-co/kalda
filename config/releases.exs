import Config

read_env = fn name ->
  System.get_env(name) ||
    raise """
    environment variable #{name} is missing.
    """
end

read_env_or = fn name, default ->
  System.get_env(name) || default
end

config :kalda, Kalda.Repo,
  ssl: true,
  url: read_env.("DATABASE_URL"),
  pool_size: String.to_integer(read_env_or.("POOL_SIZE", "10"))

config :kalda, KaldaWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: "kalda.co", port: 80],
  secret_key_base: read_env.("SECRET_KEY_BASE"),
  server: true

config :kalda,
  # Sendfox api (email signups management)
  sendfox_api_token: read_env.("SENDFOX_TOKEN"),
  # Optionally require basic browser auth
  basic_auth_password: read_env_or.("BASIC_AUTH_PASSWORD", nil),
  # Stripe payments
  stripe_publishable_key: read_env.("STRIPE_PUBLISHABLE_KEY"),
  stripe_webhook_secret: read_env.("STRIPE_WEBHOOK_SECRET"),
  stripe_subscription_price_id: read_env.("STRIPE_SUBSCRIPTION_PRICE_ID")

config :kalda, Kalda.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: read_env.("SENDGRID_API_KEY"),
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

# Enable rollbar exception tracking
config :rollbax,
  enabled: true,
  access_token: "3096585f75844cdaa1b70815ea70d849",
  environment: read_env.("ROLLBAR_ENV"),
  enable_crash_reports: true

config :stripity_stripe,
  api_key: read_env.("STRIPE_SECRET_KEY")
