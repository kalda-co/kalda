defmodule KaldaWeb.Api.V1.CommentControllerTest do
  use KaldaWeb.ConnCase

  @valid_comment_content %{
    content: "This is a comment!"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST new", ctx do
      assert ctx.conn |> post("/v1/posts/1/comments") |> json_response(401)
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

      assert conn = post(conn, "/v1/posts/#{post.id}/comments", comment: @valid_comment_content)

      assert [comment] = Kalda.Forums.get_comments()
      assert comment.content == @valid_comment_content.content
      assert comment.author_id == current_user.id
      assert comment.post_id == post.id

      assert json_response(conn, 201) == %{
               "id" => comment.id,
               "content" => @valid_comment_content.content,
               "author" => comment.author_id,
               "inserted_at" => NaiveDateTime.to_iso8601(comment.inserted_at)
             }
    end
  end
end
