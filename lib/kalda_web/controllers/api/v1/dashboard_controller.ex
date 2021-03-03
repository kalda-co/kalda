defmodule KaldaWeb.Api.V1.DashboardController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Events

  def index(conn, _params) do
    user = conn.assigns.current_user
    reflections = Forums.get_posts(:daily_reflection)
    pools = Forums.get_posts(:will_pool)
    therapy = Events.get_next_therapy_session!()

    conn
    |> render("index.json", user: user, reflections: reflections, pools: pools, therapy: therapy)
  end
end
