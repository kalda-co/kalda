defmodule KaldaWeb.Api.V1.DashboardController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Events

  # TODO: App will crash if no future therapies scheduled
  def index(conn, _params) do
    user = conn.assigns.current_user
    reflections = Forums.get_daily_reflections()
    pools = Forums.get_will_pools()
    therapy = Events.get_next_therapy_session!()

    conn
    |> render("index.json", user: user, reflections: reflections, pools: pools, therapy: therapy)
  end
end
