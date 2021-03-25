defmodule KaldaWeb.Admin.NotFoundController do
  use KaldaWeb, :controller

  def not_found(conn, _args) do
    raise Phoenix.Router.NoRouteError, conn: conn, router: KaldaWeb.Router
  end
end
