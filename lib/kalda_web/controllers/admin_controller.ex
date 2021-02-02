defmodule KaldaWeb.AdminController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  alias Kalda.Forums
  alias KaldaWeb.UserAuth
  alias Kalda.Policy

  def user_index(conn, _params) do
    user = conn.assigns.current_user
    Policy.authorize!(user, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    users = Accounts.get_users()
    render(conn, "user_index.html", users: users, error_message: "not authorised")
  end

  def post_index(conn, _params) do
    user = conn.assigns.current_user
    Policy.authorize!(user, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    posts = Forums.get_posts()
    render(conn, "post_index.html", posts: posts, error_message: "not authorised")
  end

  def post_new(conn, _params) do
    changeset = Forums.change_post(%Forums.Post{})
    render(conn, "post_new.html", changeset: changeset)
  end

  def post_create(conn, %{"post" => post_params}) do
    user = conn.assigns.current_user
    Policy.authorize!(user, :create_post, Kalda)

    case Forums.create_post(user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_path(conn, :post_show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "post_new.html", changeset: changeset)
    end
  end

  def post_show(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    render(conn, "post_show.html", post: post)
  end

  def post_edit(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    changeset = Forums.change_post(post)
    render(conn, "post_edit.html", post: post, changeset: changeset)
  end

  def post_update(conn, %{"id" => id, "post" => post_params}) do
    post = Forums.get_post!(id)

    case Forums.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_path(conn, :post_show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "post_edit.html", post: post, changeset: changeset)
    end
  end

  def post_delete(conn, %{"id" => id}) do
    post = Forums.get_post!(id)
    {:ok, _post} = Forums.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_path(conn, :post_index))
  end
end
