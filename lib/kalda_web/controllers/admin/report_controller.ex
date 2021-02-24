defmodule KaldaWeb.Admin.ReportController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    # The authorize! function knows how to get the user off the conn
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    reports =
      Forums.get_unresolved_reports(
        preload: [
          :author,
          :reporter,
          reply: [:author],
          comment: [:author, :replies]
        ]
      )

    render(conn, "index.html", reports: reports)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    report =
      Forums.get_report!(id,
        preload: [
          :author,
          :reporter,
          reply: [:author],
          comment: [:author, :replies]
        ]
      )

    changeset = Forums.Report.changeset(report, %{})

    render(conn, "edit.html", report: report, changeset: changeset)
  end
end
