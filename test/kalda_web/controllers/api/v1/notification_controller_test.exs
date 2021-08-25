defmodule KaldaWeb.Api.V1.NotificationControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET index", ctx do
      assert ctx.conn |> get("/v1/notifications") |> json_response(401)
    end
  end

  describe "GET notification index, user stripe subscibed" do
    setup [:register_and_log_in_subscribed_stripe_user]

    # TODO test the route is just for the currentuser and not all ie
    # uses /v1/notifications
    # TODO tests that other notifications not shown
    # TODO tests replis etc can be deleted and that deletes notification?
    test "list notifications if a user comment gets replies", %{
      conn: conn,
      user: current_user
    } do
      author1 = AccountsFixtures.user()
      reply_auth1 = AccountsFixtures.user()
      reply_auth2 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      comment1 = ForumsFixtures.comment(post1, current_user)

      {reply1, _notification1} = ForumsFixtures.reply_with_notification(comment1, reply_auth1)

      {reply2, _notification2} = ForumsFixtures.reply_with_notification(comment1, reply_auth2)

      conn = get(conn, "/v1/notifications")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "notifications" => %{
                 "post_notifications" => nil,
                 "comment_notifications" => [
                   %{
                     "parent_post_id" => post1.id,
                     "comment_id" => comment1.id,
                     "comment_content" => comment1.content,
                     "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                     "notification_reply_id" => reply1.id,
                     "reply_content" => reply1.content,
                     "reply_author" => %{
                       "id" => reply_auth1.id,
                       "username" => reply_auth1.username
                     }
                   },
                   %{
                     "parent_post_id" => post1.id,
                     "comment_id" => comment1.id,
                     "comment_content" => comment1.content,
                     "inserted_at" => NaiveDateTime.to_iso8601(reply2.inserted_at),
                     "notification_reply_id" => reply2.id,
                     "reply_content" => reply2.content,
                     "reply_author" => %{
                       "id" => reply_auth2.id,
                       "username" => reply_auth2.username
                     }
                   }
                 ]
               }
             }
    end

    test "list notifications only on user comment", %{
      conn: conn,
      user: current_user
    } do
      author1 = AccountsFixtures.user()
      reply_auth1 = AccountsFixtures.user()
      reply_auth2 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      comment1 = ForumsFixtures.comment(post1, current_user)

      {reply1, _notification1} = ForumsFixtures.reply_with_notification(comment1, reply_auth1)

      {reply2, _notification2} = ForumsFixtures.reply_with_notification(comment1, reply_auth2)

      user2 = AccountsFixtures.user()
      comment2 = ForumsFixtures.comment(post1, user2)
      # Reply3 should not show in notifications as it is not on a comment by current_user
      {_reply3, _notofocation3} = ForumsFixtures.reply_with_notification(comment2, reply_auth1)

      conn = get(conn, "/v1/notifications")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "notifications" => %{
                 "post_notifications" => nil,
                 "comment_notifications" => [
                   %{
                     "parent_post_id" => post1.id,
                     "comment_id" => comment1.id,
                     "comment_content" => comment1.content,
                     "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                     "notification_reply_id" => reply1.id,
                     "reply_content" => reply1.content,
                     "reply_author" => %{
                       "id" => reply_auth1.id,
                       "username" => reply_auth1.username
                     }
                   },
                   %{
                     "parent_post_id" => post1.id,
                     "comment_id" => comment1.id,
                     "comment_content" => comment1.content,
                     "inserted_at" => NaiveDateTime.to_iso8601(reply2.inserted_at),
                     "notification_reply_id" => reply2.id,
                     "reply_content" => reply2.content,
                     "reply_author" => %{
                       "id" => reply_auth2.id,
                       "username" => reply_auth2.username
                     }
                   }
                 ]
               }
             }
    end
  end

  describe "GET notification index, unsubscibed user" do
    setup [:register_and_log_in_user]

    test "does not list notifications", %{
      conn: conn,
      user: _current_user
    } do
      conn = get(conn, "/v1/notifications")

      assert json_response(conn, 402) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end
  end
end
