defmodule KaldaWeb.Api.V1.ReplyControllerTest do
  use KaldaWeb.ConnCase

  @valid_reply_content %{
    content: "This is a reply!"
  }
  @invalid_reply_content %{
    content: ""
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST create", ctx do
      assert ctx.conn |> post("/v1/comments/1/replies") |> json_response(401)
    end
  end

  describe "POST create" do
    setup [:register_and_log_in_user]

    test "creates reply for user on comment in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn = post(conn, "/v1/comments/#{comment.id}/replies", @valid_reply_content)

      assert [reply] = Kalda.Forums.get_replies()
      assert reply.content == @valid_reply_content.content
      assert reply.author_id == current_user.id
      assert reply.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "id" => reply.id,
               "content" => @valid_reply_content.content,
               "author" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "comment_id" => reply.comment_id,
               "reactions" => [],
               "inserted_at" => NaiveDateTime.to_iso8601(reply.inserted_at)
             }
    end

    test "renders 422 with errors for invalid attributes", %{conn: conn, user: _current_user} do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn = post(conn, "/v1/comments/#{comment.id}/replies", @invalid_reply_content)

      assert json_response(conn, 422) == %{
               "errors" => %{"content" => ["can't be blank"]}
             }
    end
  end
end
