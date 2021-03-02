defmodule KaldaWeb.Admin.ReportControllerTest do
  use KaldaWeb.ConnCase

  describe "report_index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_report_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "report_index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all reports if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_report_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Reports"
    end
  end

  describe "POST edit" do
    test "render for if admin" do
    end

    test "do not render form if not admin" do
    end
  end

  describe "PUT update" do
    setup [:register_and_log_in_admin]

    test "update comment with selection 1 deletes comment" do
    end

    test "update comment with selection 2 preserves comment" do
    end
  end
end
