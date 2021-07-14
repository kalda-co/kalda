defmodule KaldaWeb.Api.V1.CommentReactionControllerTest do
  use KaldaWeb.ConnCase

  @valid_comment_reaction_content %{
    relate: true
  }
  @valid_comment_reaction_love_content %{
    send_love: true
  }
  @invalid_comment_reaction_content %{
    relate: nil
  }
  @valid_comment_reaction_update %{
    relate: false,
    send_love: false
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "PATCH update", ctx do
      assert ctx.conn |> patch("/v1/comments/1/reactions") |> json_response(401)
    end
  end

  describe "POST create comment reaction" do
    setup [:register_and_log_in_subscribed_user]

    test "creates comment_reaction relate for user on comment in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @valid_comment_reaction_content
               )

      assert [comment_reaction] = Kalda.Forums.get_comment_reactions(comment)
      assert comment_reaction.relate == @valid_comment_reaction_content.relate
      assert comment_reaction.author_id == current_user.id
      assert comment_reaction.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "relate" => @valid_comment_reaction_content.relate,
               "send_love" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }
    end

    test "creates comment_reaction send_love for user on comment", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @valid_comment_reaction_love_content
               )

      assert [comment_reaction] = Kalda.Forums.get_comment_reactions(comment)
      assert comment_reaction.send_love == @valid_comment_reaction_love_content.send_love
      assert comment_reaction.author_id == current_user.id
      assert comment_reaction.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "send_love" => @valid_comment_reaction_love_content.send_love,
               "relate" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }
    end

    test "updates comment_reaction for user on comment", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @valid_comment_reaction_love_content
               )

      assert [comment_reaction] = Kalda.Forums.get_comment_reactions(comment)
      assert comment_reaction.send_love == @valid_comment_reaction_love_content.send_love
      assert comment_reaction.author_id == current_user.id
      assert comment_reaction.comment_id == comment.id

      assert json_response(conn, 201) == %{
               "send_love" => true,
               "relate" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @valid_comment_reaction_update
               )

      assert json_response(conn, 201) == %{
               "send_love" => false,
               "relate" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }

      assert [comment_reaction] = Kalda.Forums.get_comment_reactions(comment)
      assert comment_reaction.send_love == false
      assert comment_reaction.relate == false
    end

    test "renders 422 with errors for invalid attributes", %{conn: conn, user: _current_user} do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @invalid_comment_reaction_content
               )

      assert json_response(conn, 422) == %{
               "errors" => %{"relate" => ["can't be blank"]}
             }
    end
  end

  describe "POST create comment reaction not allowed for unsubscribed user" do
    setup [:register_and_log_in_user]

    test "does not create comment_reaction relate for user on comment", %{
      conn: conn,
      user: _current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @valid_comment_reaction_content
               )

      assert json_response(conn, 402) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end

    test "does not post comment_reaction with invalid attributes for unsubscribed user", %{
      conn: conn,
      user: _current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      assert conn =
               patch(
                 conn,
                 "/v1/comments/#{comment.id}/reactions",
                 @invalid_comment_reaction_content
               )

      assert json_response(conn, 402) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end
  end
end
