defmodule KaldaWeb.Admin.ForumController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def daily_reflection_index(conn, _params) do
    Policy.authorize!(conn, :view_admin_posts, Kalda)
    # TODO add pagination, do not get all users
    posts = Forums.get_daily_reflections()

    render(conn, "daily_reflection_index.html", posts: posts)
  end

  def daily_reflection_new(conn, _params) do
    Policy.authorize!(conn, :create_admin_post, Kalda)
    changeset = Forums.change_daily_reflection(%Forums.Post{})
    render(conn, "daily_reflection_new.html", changeset: changeset)
  end

  def daily_reflection_create(conn, %{"post" => params}) do
    user = conn.assigns.current_user
    Policy.authorize!(conn, :create_admin_post, Kalda)

    case Forums.create_daily_reflection(user, params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_forum_path(conn, :daily_reflection_index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "daily_reflection_new.html", changeset: changeset)
    end
  end
end
