defmodule KaldaWeb.Api.V1.ReportView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{report: report}) do
    render_report(report)
  end

  def render_report(report) do
    %{
      id: report.id,
      reporter_reason: report.reporter_reason,
      reporter: UserView.render_author(report.reporter),
      comment_id: report.comment_id,
      inserted_at: report.inserted_at
    }
  end
end
