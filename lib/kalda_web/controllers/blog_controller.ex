defmodule KaldaWeb.BlogController do
  use KaldaWeb, :controller

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def show(conn, params) do
    post = Kalda.Blog.get_post_by_id!(params["id"])

    date_string = Kalda.Blog.date_string(post.date)

    conn
    |> assign(:page_title, post.title)
    |> assign(:page_description, post.description)
    |> assign(:date_string, date_string)
    |> render("show.html", post: post)
  end
end
