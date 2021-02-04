defmodule KaldaWeb.Api.V1.CommentControllerTest do
  use KaldaWeb.ConnCase

  @valid_comment_content "This is a comment"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET new", ctx do
      assert ctx.conn |> get("/v1/daily-reflections/1/comment") |> json_response(401)
    end
  end

  describe "POST create" do
    setup [:register_and_log_in_user]

    test "creates comment for user on post in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)

      params = %{
        "comment" => %{
          "content" => @valid_comment_content
        }
      }

      conn = post(conn, "/v1/daily-reflections/#{post.id}/comment", params)
    end
  end

  test "redirects to daily reflections with user post", %{conn: conn, user: current_user} do
  end
end
