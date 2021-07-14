defmodule KaldaWeb.Api.V1.ReplyReactionControllerTest do
  use KaldaWeb.ConnCase

  @valid_reply_reaction_content %{
    relate: true
  }
  @valid_reply_reaction_love_content %{
    send_love: true
  }
  @invalid_reply_reaction_content %{
    relate: nil
  }
  @valid_reply_reaction_update %{
    relate: false,
    send_love: false
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "PATCH update", ctx do
      assert ctx.conn |> patch("/v1/replies/1/reactions") |> json_response(401)
    end
  end

  describe "PATCH update" do
    setup [:register_and_log_in_subscribed_user]

    test "creates reply_reaction relate for user on reply in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @valid_reply_reaction_content
               )

      assert [reply_reaction] = Kalda.Forums.get_reply_reactions(reply)
      assert reply_reaction.relate == @valid_reply_reaction_content.relate
      assert reply_reaction.author_id == current_user.id
      assert reply_reaction.reply_id == reply.id

      assert json_response(conn, 201) == %{
               "relate" => @valid_reply_reaction_content.relate,
               "send_love" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }
    end

    test "creates reply_reaction send_love for user on reply", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @valid_reply_reaction_love_content
               )

      assert [reply_reaction] = Kalda.Forums.get_reply_reactions(reply)
      assert reply_reaction.send_love == @valid_reply_reaction_love_content.send_love
      assert reply_reaction.author_id == current_user.id
      assert reply_reaction.reply_id == reply.id

      assert json_response(conn, 201) == %{
               "send_love" => @valid_reply_reaction_love_content.send_love,
               "relate" => false,
               "author" => %{
                 "has_subscription" => true,
                 "id" => current_user.id,
                 "username" => current_user.username
               }
             }
    end

    test "updates reply_reaction for user on reply", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @valid_reply_reaction_love_content
               )

      assert [reply_reaction] = Kalda.Forums.get_reply_reactions(reply)
      assert reply_reaction.send_love == @valid_reply_reaction_love_content.send_love
      assert reply_reaction.author_id == current_user.id
      assert reply_reaction.reply_id == reply.id

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
                 "/v1/replies/#{reply.id}/reactions",
                 @valid_reply_reaction_update
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

      assert [reply_reaction] = Kalda.Forums.get_reply_reactions(reply)
      assert reply_reaction.send_love == false
      assert reply_reaction.relate == false
    end

    test "renders 422 with errors for invalid attributes", %{conn: conn, user: _current_user} do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @invalid_reply_reaction_content
               )

      assert json_response(conn, 422) == %{
               "errors" => %{"relate" => ["can't be blank"]}
             }
    end
  end

  describe "PATCH update with unsubscribed user" do
    setup [:register_and_log_in_user]

    test "does not create reply_reaction relate for user on reply in daily reflections", %{
      conn: conn,
      user: _current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @valid_reply_reaction_content
               )

      assert json_response(conn, 401) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end

    test "renders 401 with invalid attributes as not submitted", %{
      conn: conn,
      user: _current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      assert conn =
               patch(
                 conn,
                 "/v1/replies/#{reply.id}/reactions",
                 @invalid_reply_reaction_content
               )

      assert json_response(conn, 401) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end
  end
end
