defmodule KaldaWeb.BlogController do
  use KaldaWeb, :controller

  def show(conn, params) do
    post = Kalda.Blog.get_post_by_id!(params["id"])

    conn
    |> render("show.html", post: post)
  end
end
