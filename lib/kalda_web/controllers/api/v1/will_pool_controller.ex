defmodule KaldaWeb.Api.V1.WillPoolController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user
    posts = Forums.get_will_pools()

    conn
    |> render("index.json", user: user, posts: posts)
  end
end
