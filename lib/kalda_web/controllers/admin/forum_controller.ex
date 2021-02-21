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
end
