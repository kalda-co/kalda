defmodule KaldaWeb.Api.V1.NotificationControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET index", ctx do
      assert ctx.conn |> get("/v1/users/1/notifications") |> json_response(401)
    end
  end

  describe "GET index" do
    setup [:register_and_log_in_user]

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
      reply1 = ForumsFixtures.reply(comment1, reply_auth1)
      reply2 = ForumsFixtures.reply(comment1, reply_auth2)

      # TODO daily reflection posts should generate a notification to all users??

      conn = get(conn, "/v1/users/1/notifications")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "notifications" => [
                 %{
                   "post_notifications" => nil,
                   "comment_notifications" => [
                     %{
                       "id" => comment1.id,
                       "content" => comment1.content,
                       "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                       "author" => %{
                         "id" => current_user.id,
                         "username" => current_user.username
                       },
                       "reactions" => [],
                       "replies" => [
                         %{
                           "id" => reply1.id,
                           "content" => reply1.content,
                           "comment_id" => comment1.id,
                           "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                           "reactions" => [],
                           "author" => %{
                             "id" => reply_auth1.id,
                             "username" => reply_auth1.username
                           }
                         },
                         %{
                           "id" => reply2.id,
                           "content" => reply2.content,
                           "comment_id" => comment1.id,
                           "inserted_at" => NaiveDateTime.to_iso8601(reply2.inserted_at),
                           "reactions" => [],
                           "author" => %{
                             "id" => reply_auth2.id,
                             "username" => reply_auth2.username
                           }
                         }
                       ]
                     }
                   ]
                 }
               ]
             }
    end
  end
end
