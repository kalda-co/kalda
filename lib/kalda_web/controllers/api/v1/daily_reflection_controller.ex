defmodule KaldaWeb.Api.V1.DailyReflectionController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user
    reflections = Forums.get_daily_reflections()
    pools = Forums.get_will_pools()

    conn
    |> render("index.json", user: user, reflections: reflections, pools: pools)
  end
end
