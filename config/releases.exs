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
