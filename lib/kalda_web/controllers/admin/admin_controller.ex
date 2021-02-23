defmodule KaldaWeb.Admin.AdminController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin, Kalda)

    [latest_daily_reflection] = Forums.get_forums_posts_limit(:daily_reflection, 1)
    changeset = Forums.change_daily_reflection(%Forums.Post{})

    render(conn, "index.html", daily_reflection: latest_daily_reflection, changeset: changeset)
  end
end
