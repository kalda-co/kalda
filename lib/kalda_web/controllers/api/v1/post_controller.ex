defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    posts = Forums.get_posts(preload: [:author, comments: [:author, replies: [:author]]])

    conn
    |> render("index.json", posts: posts)
  end
end
