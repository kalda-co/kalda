defmodule KaldaWeb.StaticHelpers do
  @spa_prefix Application.get_env(:kalda, :spa_static_prefix)

  def spa_static_path(path) do
    @spa_prefix <> path
  end
end
