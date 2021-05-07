defmodule Kalda.Repo do
  use Ecto.Repo,
    otp_app: :kalda,
    adapter: Ecto.Adapters.Postgres
end
