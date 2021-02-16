defmodule KaldaWeb.Admin.ReportController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    # The authorize! function knows how to get the user off the conn
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    reports = Forums.get_unresolved_reports()
    render(conn, "index.html", reports: reports, error_message: "not authorised")
  end
end
