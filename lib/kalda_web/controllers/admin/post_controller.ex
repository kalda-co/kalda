defmodule KaldaWeb.Admin.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, params) do
    Policy.authorize!(conn, :view_admin_posts, Kalda)
    forum = Forums.parse_forum!(params["forum"])
    user = conn.assigns.current_user
    posts = Forums.get_posts(user, forum)
    scheduled = Forums.get_scheduled_posts(forum)
    name_string = Forums.name_string(forum)

    render(conn, "index.html",
      posts: posts,
      scheduled: scheduled,
      forum: forum,
      name_string: name_string
    )
  end

  def new(conn, params) do
    Policy.authorize!(conn, :create_admin_post, Kalda)
    forum = Forums.parse_forum!(params["forum"])
    name_string = Forums.name_string(forum)
    changeset = Forums.change_post(%Forums.Post{forum: forum})
    render(conn, "new.html", changeset: changeset, forum: forum, name_string: name_string)
  end

  def create(conn, %{"post" => post_params}) do
    # forum = Forums.parse_forum!(params["forum"])
    user = conn.assigns.current_user
    Policy.authorize!(conn, :create_admin_post, Kalda)

    case Forums.create_post(user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "#{post.forum} post created successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :index, post.forum))

      {:error, %Ecto.Changeset{} = changeset} ->
        forum = Ecto.Changeset.get_field(changeset, :forum, :daily_reflection)
        name_string = Forums.name_string(forum)
        render(conn, "new.html", changeset: changeset, forum: forum, name_string: name_string)
    end
  end

  def show(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_post, Kalda)
    post = Forums.get_post!(id)
    forum = post.forum
    render(conn, "show.html", post: post, forum: forum)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :edit_admin_post, Kalda)
    post = Forums.get_post!(id)
    changeset = Forums.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, forum: post.forum)
  end

  def update(conn, %{"id" => id, "post" => params}) do
    Policy.authorize!(conn, :edit_admin_post, Kalda)
    post = Forums.get_post!(id)
    forum = post.forum

    case Forums.update_post(post, params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Daily Reflection updated successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, forum: forum)
    end
  end

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_post, Kalda)
    post = Forums.get_post!(id)
    {:ok, post} = Forums.delete_post(post)

    conn
    |> put_flash(:info, "Daily Reflection deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index, post.forum))
  end
end
