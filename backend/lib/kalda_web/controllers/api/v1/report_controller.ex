defmodule KaldaWeb.Api.V1.ReportController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.Report

  def report_comment(conn, %{"id" => comment_id} = report_params) do
    user = conn.assigns.current_user
    comment = Forums.get_comment!(comment_id)

    with {:ok, %Report{} = report} <- Forums.report_comment(user, comment, report_params) do
      report = report |> Map.put(:reporter, user)

      conn
      |> put_status(201)
      |> render("show.json", report: report)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end

  def report_reply(conn, %{"id" => reply_id} = report_params) do
    user = conn.assigns.current_user
    reply = Forums.get_reply!(reply_id)

    with {:ok, %Report{} = report} <- Forums.report_reply(user, reply, report_params) do
      report = report |> Map.put(:reporter, user)

      conn
      |> put_status(201)
      |> render("show.json", report: report)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
