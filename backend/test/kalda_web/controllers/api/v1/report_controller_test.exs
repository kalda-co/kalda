defmodule KaldaWeb.Api.V1.ReportControllerTest do
  use KaldaWeb.ConnCase

  @valid_reporter_reason_content %{
    reporter_reason: "I report this inappropriate"
  }

  # @invalid_reporter_reason_content %{
  #   reporter_reason: ""
  # }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST report_comment", ctx do
      assert ctx.conn |> post("/v1/comments/1/reports") |> json_response(401)
    end
  end

  describe "POST report_comment" do
    setup [:register_and_log_in_user]

    test "creates report for user (reporter) on a comment in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               post(conn, "/v1/comments/#{comment.id}/reports", @valid_reporter_reason_content)

      assert [report] = Kalda.Forums.get_reports()
      assert report.reporter_reason == @valid_reporter_reason_content.reporter_reason
      assert report.reporter_id == current_user.id
      assert report.author_id == user.id
      assert report.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "id" => report.id,
               "reporter_reason" => @valid_reporter_reason_content.reporter_reason,
               "reporter" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "comment_id" => report.comment_id,
               "post_id" => nil,
               "reply_id" => nil,
               "inserted_at" => NaiveDateTime.to_iso8601(report.inserted_at)
             }
    end
  end

  describe "POST report_reply" do
    setup [:register_and_log_in_user]

    test "creates report for user (reporter) on a reply in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn = post(conn, "/v1/replies/#{reply.id}/reports", @valid_reporter_reason_content)

      assert [report] = Kalda.Forums.get_reports()
      assert report.reporter_reason == @valid_reporter_reason_content.reporter_reason
      assert report.reporter_id == current_user.id
      assert report.author_id == user.id
      assert report.reply_id == reply.id

      assert json_response(conn, 201) == %{
               "id" => report.id,
               "reporter_reason" => @valid_reporter_reason_content.reporter_reason,
               "reporter" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "reply_id" => report.reply_id,
               "post_id" => nil,
               "comment_id" => nil,
               "inserted_at" => NaiveDateTime.to_iso8601(report.inserted_at)
             }
    end
  end
end
