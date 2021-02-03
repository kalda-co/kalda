defmodule KaldaWeb.Admin.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    posts = Forums.get_posts(preload: [:author, comments: [:author, replies: [:author]]])

    render(conn, "index.html",
      posts: posts,
      error_message: "not authorised"
    )
  end

  def new(conn, _params) do
    changeset = Forums.change_post(%Forums.Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => params}) do
    user = conn.assigns.current_user
    Policy.authorize!(conn, :create_post, Kalda)

    case Forums.create_post(user, params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    changeset = Forums.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => params}) do
    post = Forums.get_post!(id)

    case Forums.update_post(post, params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    {:ok, _post} = Forums.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index))
  end
end
