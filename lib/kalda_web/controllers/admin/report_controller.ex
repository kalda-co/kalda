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
          comment: [:author, replies: [:author]]
        ]
      )

    resolveds =
      Forums.get_resolved_reports(
        preload: [
          :author,
          :reporter,
          :moderator,
          reply: [:author],
          comment: [:author, replies: [:author]]
        ]
      )

    render(conn, "index.html", reports: reports, resolveds: resolveds)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    report =
      Forums.get_report!(id,
        preload: [
          :author,
          :reporter,
          reply: [:author],
          comment: [:author, replies: [:author]]
        ]
      )

    changeset = Forums.Report.changeset(report, %{})

    render(conn, "edit.html", report: report, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "report" => %{"moderator_reason" => moderator_reason, "selection" => selection}
      }) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    current_user = conn.assigns.current_user

    report =
      Forums.get_report!(id,
        preload: [
          :author,
          :reporter,
          reply: [:author],
          comment: [:author, replies: [:author]]
        ]
      )

    if report.comment do
      Forums.moderate_report_comment(
        report,
        report.comment,
        selection,
        current_user.id,
        moderator_reason
      )

      conn
      |> put_flash(:info, "This report has been resolved")
      |> redirect(to: Routes.admin_report_path(conn, :index))
    else
      Forums.moderate_report_reply(
        report,
        report.reply,
        selection,
        current_user.id,
        moderator_reason
      )

      conn
      |> put_flash(:info, "This report has been resolved")
      |> redirect(to: Routes.admin_report_path(conn, :index))
    end
  end
end
