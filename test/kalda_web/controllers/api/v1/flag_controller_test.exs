defmodule KaldaWeb.Api.V1.FlagControllerTest do
  use KaldaWeb.ConnCase

  @valid_reporter_reason_content %{
    reporter_reason: "I flag this inappropriate"
  }

  # @invalid_reporter_reason_content %{
  #   reporter_reason: ""
  # }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST create_flag_comment", ctx do
      assert ctx.conn |> post("/v1/comments/1/flags") |> json_response(401)
    end
  end

  describe "POST create_flag_comment" do
    setup [:register_and_log_in_user]

    test "creates flag for user (reporter) on a comment in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn = post(conn, "/v1/comments/#{comment.id}/flags", @valid_reporter_reason_content)

      assert [flag] = Kalda.Forums.get_flags()
      assert flag.reporter_reason == @valid_reporter_reason_content.reporter_reason
      assert flag.reporter_id == current_user.id
      assert flag.author_id == user.id
      assert flag.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "id" => flag.id,
               "reporter_reason" => @valid_reporter_reason_content.reporter_reason,
               "reporter" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "comment_id" => flag.comment_id,
               "inserted_at" => NaiveDateTime.to_iso8601(flag.inserted_at)
             }
    end
  end
end
