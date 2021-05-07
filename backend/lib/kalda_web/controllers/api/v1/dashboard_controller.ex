defmodule KaldaWeb.Api.V1.DashboardController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Events

  def index(conn, _params) do
    user = conn.assigns.current_user
    reflections = Forums.get_posts(:daily_reflection, limit: 10)
    pools = Forums.get_posts(:will_pool, limit: 10)
    next_therapy = Events.get_next_therapy_session!()
    therapies = Events.get_therapy_sessions(limit: 10)

    conn
    |> render("index.json",
      user: user,
      reflections: reflections,
      pools: pools,
      next_therapy: next_therapy,
      therapies: therapies
    )
  end
end
