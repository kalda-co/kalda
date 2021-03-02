defmodule KaldaWeb.Admin.ReportControllerTest do
  use KaldaWeb.ConnCase

  @moderated_report_params %{
    moderator_reason: "Yes, good reason",
    moderator_action: :delete
  }

  @moderated_report_params2 %{
    moderator_reason: "Yes, good reason",
    moderator_action: :do_nothing
  }

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
    setup [:register_and_log_in_admin]

    test "render form if admin", %{conn: conn, user: user} do
      author = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(author)
      comment = Kalda.ForumsFixtures.comment(post, author)
      report = Kalda.ForumsFixtures.unmoderated_report(user, "comment", comment)

      conn = get(conn, Routes.admin_report_path(conn, :edit, report))
      assert html_response(conn, 200) =~ "Moderate this content"
    end
  end

  describe "POST edit as not admin" do
    setup [:register_and_log_in_user]

    test "do not render form if not admin", %{conn: conn, user: user} do
      author = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(author)
      comment = Kalda.ForumsFixtures.comment(post, author)
      report = Kalda.ForumsFixtures.unmoderated_report(user, "comment", comment)

      conn = get(conn, Routes.admin_report_path(conn, :edit, report))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "PUT update" do
    setup [:register_and_log_in_admin]

    test "update comment with selection 1 deletes comment", %{conn: conn, user: user} do
      author = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(author)
      comment = Kalda.ForumsFixtures.comment(post, author)
      report = Kalda.ForumsFixtures.unmoderated_report(user, "comment", comment)

      conn =
        put(
          conn,
          Routes.admin_report_path(conn, :update, report.id, report: @moderated_report_params)
        )

      assert get_flash(conn, :info) == "This report has been resolved"
      assert redirected_to(conn, 302) =~ "/admin/reports"
      refute Kalda.Admin.list_archived() == []
    end

    test "update comment with selection 2 preserves comment", %{conn: conn, user: user} do
      author = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(author)
      comment = Kalda.ForumsFixtures.comment(post, author)
      report = Kalda.ForumsFixtures.unmoderated_report(user, "comment", comment)

      conn =
        put(
          conn,
          Routes.admin_report_path(conn, :update, report.id, report: @moderated_report_params2)
        )

      assert get_flash(conn, :info) == "This report has been resolved"
      assert redirected_to(conn, 302) =~ "/admin/reports"
      assert Kalda.Admin.list_archived() == []
    end
  end
end
