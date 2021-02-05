defmodule KaldaWeb.Api.V1.DailyReflectionController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user
    posts = Forums.get_posts(preload: [:author, comments: [:author, replies: [:author]]])

    conn
    |> render("index.json", user: user, posts: posts)
  end
end
