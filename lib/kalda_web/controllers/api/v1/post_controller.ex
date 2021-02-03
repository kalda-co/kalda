defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user
    Kalda.Policy.authorize!(user, :view_api_index, Kalda)
    posts = Forums.get_posts(preload: [:author, comments: [:author, replies: [:author]]])

    conn
    |> render("index.json", posts: posts)
  end
end
