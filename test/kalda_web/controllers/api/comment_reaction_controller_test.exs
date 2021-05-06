defmodule KaldaWeb.Api.V1.CommentReactionControllerTest do
  use KaldaWeb.ConnCase

  @valid_comment_reaction_content %{
    relate: true
  }
  @invalid_comment_reaction_content %{
    relate: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST create", ctx do
      assert ctx.conn |> post("/v1/comments/1/comment_reactions") |> json_response(401)
    end
  end

  describe "POST create" do
    setup [:register_and_log_in_user]

    test "creates comment_reaction for user on comment in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               post(
                 conn,
                 "/v1/comments/#{comment.id}/comment_reactions",
                 @valid_comment_reaction_content
               )

      assert [comment_reaction] = Kalda.Forums.get_comment_reactions(comment)
      assert comment_reaction.relate == @valid_comment_reaction_content.relate
      assert comment_reaction.author_id == current_user.id
      assert comment_reaction.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "id" => comment_reaction.id,
               "relate" => @valid_comment_reaction_content.relate,
               "send_love" => false,
               "author" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "comment_id" => comment_reaction.comment_id,
               "inserted_at" => NaiveDateTime.to_iso8601(comment_reaction.inserted_at)
             }
    end

    test "renders 422 with errors for invalid attributes", %{conn: conn, user: _current_user} do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               post(
                 conn,
                 "/v1/comments/#{comment.id}/comment_reactions",
                 @invalid_comment_reaction_content
               )

      assert json_response(conn, 422) == %{
               "errors" => %{"relate" => ["can't be blank"]}
             }
    end
  end
end
