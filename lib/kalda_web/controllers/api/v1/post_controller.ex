defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  action_fallback KaldaWeb.Api.FallbackController

  def index(conn, _params) do
    posts = Forums.get_posts(preload: [:author, comments: [:author, replies: [:author]]])

    conn
    |> render("index.json", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Forums.get_post!(id, preload: [:author, comments: [:author, replies: [:author]]])
    render(conn, "show.json", post: post)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Forums.Post{} = post} <- Forums.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end
end
