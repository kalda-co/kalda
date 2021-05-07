defmodule KaldaWeb.StaticHelpers do
  @spa_prefix Application.get_env(:kalda, :spa_static_prefix)

  if @spa_prefix do
    def spa_static_path(path), do: @spa_prefix <> path
  else
    def spa_static_path(path), do: KaldaWeb.Router.Helpers.static_path(KaldaWeb.Endpoint, path)
  end
end
