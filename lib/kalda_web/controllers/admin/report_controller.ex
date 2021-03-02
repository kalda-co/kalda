defmodule KaldaWeb.Admin.ReportController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    # The authorize! function knows how to get the user off the conn
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    reports = Forums.get_unresolved_reports(preload: preloads())

    resolveds = Forums.get_resolved_reports(preload: preloads())

    render(conn, "index.html", reports: reports, resolveds: resolveds)
  end

  def edit(conn, %{"id" => id}) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    report = Forums.get_report!(id, preload: preloads())

    changeset = Forums.Report.moderation_changeset(report, %{})

    render(conn, "edit.html", report: report, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "report" => params
      }) do
    moderator_reason = params["moderator_reason"]
    moderator_action = params["moderator_action"]

    Policy.authorize!(conn, :view_admin_pages, Kalda)
    current_user = conn.assigns.current_user

    report = Forums.get_report!(id, preload: preloads())

    case Forums.moderate_report(
           report,
           moderator_action,
           current_user.id,
           moderator_reason
         ) do
      {:ok, _report} ->
        conn
        |> put_flash(:info, "This report has been resolved")
        |> redirect(to: Routes.admin_report_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> render("edit.html", report: report, changeset: changeset)
    end
  end

  defp preloads() do
    [
      :author,
      :reporter,
      :moderator,
      reply: [:author],
      comment: [:author, replies: [:author]]
    ]
  end
end
