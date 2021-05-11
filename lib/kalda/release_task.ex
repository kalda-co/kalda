defmodule Kalda.ReleaseTask do
  @moduledoc """
  Responsible for custom release commands
  """
  @app :kalda

  def migrate do
    # We don't start the entire Kalda app as it expects the database to be migrated
    {:ok, _} = Application.ensure_all_started(:ssl)

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _} = Application.ensure_all_started(:ssl)
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    {:ok, _} = Application.ensure_all_started(@app)
    Kalda.ReleaseTask.Seeds.insert!()
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
