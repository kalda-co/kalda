defmodule KaldaWeb.BlogController do
  use KaldaWeb, :controller

  alias Kalda.EmailLists
  alias Kalda.EmailLists.Signup

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def show(conn, params) do
    post = Kalda.Blog.get_post_by_id!(params["id"])

    date_string = Kalda.Blog.date_string(post.date)

    signup_changeset = EmailLists.change_signup(%Signup{})

    # TODO: add alt image text as a param here
    conn
    |> assign(:page_title, post.title)
    |> assign(:page_description, post.description)
    |> assign(:date_string, date_string)
    |> render("show.html", post: post, signup_changeset: signup_changeset)
  end

  def index(conn, _params) do
    [featured | posts] = Kalda.Blog.all_posts()

    conn
    |> render("index.html", posts: posts, featured: featured)
  end
end
