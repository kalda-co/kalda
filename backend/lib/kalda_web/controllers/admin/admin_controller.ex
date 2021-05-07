defmodule KaldaWeb.Admin.AdminController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin, Kalda)

    changeset = Forums.change_daily_reflection(%Forums.Post{})

    reports =
      Forums.get_unresolved_reports(
        preload: [
          :author,
          :reporter,
          reply: [:author],
          comment: [:author, :replies]
        ]
      )

    render(conn, "index.html",
      changeset: changeset,
      reports: reports
    )
  end
end
