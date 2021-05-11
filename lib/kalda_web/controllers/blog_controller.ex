defmodule KaldaWeb.BlogController do
  use KaldaWeb, :controller

  alias Kalda.Waitlist
  alias Kalda.Waitlist.Signup

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def show(conn, params) do
    post = Kalda.Blog.get_post_by_id!(params["id"])

    date_string = Kalda.Blog.date_string(post.date)

    signup_changeset = Waitlist.change_signup(%Signup{})

    # TODO: add alt image text as a param here
    conn
    |> assign(:page_title, post.title)
    |> assign(:page_description, post.description)
    |> assign(:date_string, date_string)
    |> render("show.html", post: post, signup_changeset: signup_changeset)
  end

  def index(conn, _params) do
    p_all = Kalda.Blog.all_posts()
    {featured, posts} = List.pop_at(p_all, 0)

    conn
    |> render("index.html", posts: posts, featured: featured)
  end
end
