defmodule Kalda.Repo do
  use Ecto.Repo,
    otp_app: :kalda,
    adapter: Ecto.Adapters.Postgres

  def transaction!(fun) do
    {:ok, value} = transaction(fun)
    value
  end
end
