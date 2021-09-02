defmodule KaldaWeb.Api.V1.PostControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  # TODO: test the token version of this pipeline!!!

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET show", ctx do
      assert ctx.conn |> get("/v1/posts/1") |> json_response(401)
    end
  end

  describe "GET show" do
    setup [:register_and_log_in_subscribed_user]

    test "shows post, comments, replies", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      comment1 = ForumsFixtures.comment(post1, current_user, %{content: "abc"})
      comment2 = ForumsFixtures.comment(post1, author1)
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/posts/#{post1.id}")

      assert json_response(conn, 200) == %{
               #  "forum" => post1.forum,
               "forum" => "daily_reflection",
               "id" => post1.id,
               "published_at" => NaiveDateTime.to_iso8601(post1.published_at),
               "content" => post1.content,
               "author" => %{
                 "id" => author1.id,
                 "username" => author1.username
               },
               "comments" => [
                 %{
                   "id" => comment1.id,
                   "content" => comment1.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                   "reactions" => [],
                   "author" => %{
                     "id" => current_user.id,
                     "username" => current_user.username
                   },
                   "replies" => [
                     %{
                       "id" => reply1.id,
                       "content" => reply1.content,
                       "comment_id" => comment1.id,
                       "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                       "reactions" => [],
                       "author" => %{
                         "id" => author1.id,
                         "username" => author1.username
                       }
                     }
                   ]
                 },
                 %{
                   "id" => comment2.id,
                   "content" => comment2.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment2.inserted_at),
                   "reactions" => [],
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "replies" => []
                 }
               ]
             }
    end
  end

  describe "GET index for unsubscribed user" do
    setup [:register_and_log_in_user]

    test "shows nothing?", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      comment1 = ForumsFixtures.comment(post1, current_user)
      _comment2 = ForumsFixtures.comment(post1, author1)
      _reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/posts/#{post1.id}")

      assert json_response(conn, 402) == %{
               "error" => "You must be subscribed to access this resource"
             }
    end
  end

  # TODO: Fix test/functionality as this takes ages to run
  describe "GET show_read" do
    # This route contains the notification id as the post Id is accessibe from that
    setup [:register_and_log_in_subscribed_user]

    test "returns post, comments, replies to frontend AND updaes notification to read: true", %{
      conn: conn,
      user: current_user
    } do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      comment1 = ForumsFixtures.comment(post1, current_user, %{content: "abc"})
      comment2 = ForumsFixtures.comment(post1, author1)
      {reply1, notification1} = ForumsFixtures.reply_with_notification(comment1, author1)
      conn = get(conn, "/v1/posts/notifications/#{notification1.id}")

      assert json_response(conn, 200) == %{
               #  "forum" => post1.forum,
               "forum" => "daily_reflection",
               "id" => post1.id,
               "published_at" => NaiveDateTime.to_iso8601(post1.published_at),
               "content" => post1.content,
               "author" => %{
                 "id" => author1.id,
                 "username" => author1.username
               },
               "comments" => [
                 %{
                   "id" => comment1.id,
                   "content" => comment1.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                   "reactions" => [],
                   "author" => %{
                     "id" => current_user.id,
                     "username" => current_user.username
                   },
                   "replies" => [
                     %{
                       "id" => reply1.id,
                       "content" => reply1.content,
                       "comment_id" => comment1.id,
                       "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                       "reactions" => [],
                       "author" => %{
                         "id" => author1.id,
                         "username" => author1.username
                       }
                     }
                   ]
                 },
                 %{
                   "id" => comment2.id,
                   "content" => comment2.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment2.inserted_at),
                   "reactions" => [],
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "replies" => []
                 }
               ]
             }

      assert notification1.read == false
      updated_notification = Kalda.Forums.get_notification!(notification1.id)
      assert updated_notification.read == true
    end
  end
end
