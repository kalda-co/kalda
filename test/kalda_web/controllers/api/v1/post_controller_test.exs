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

    # test "shows post, comments, replies", %{conn: conn, user: current_user} do
    #   author1 = AccountsFixtures.user()

    #   post1 =
    #     ForumsFixtures.post(author1, %{
    #       published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
    #     })

    #   comment1 = ForumsFixtures.comment(post1, current_user, %{content: "abc"})
    #   comment2 = ForumsFixtures.comment(post1, author1)
    #   reply1 = ForumsFixtures.reply(comment1, author1)
    #   conn = get(conn, "/v1/posts/#{post1.id}/comments/#{comment1.id}")

    #   assert json_response(conn, 200) == %{
    #            #  "forum" => post1.forum,
    #            "forum" => "daily_reflection",
    #            "id" => post1.id,
    #            "published_at" => NaiveDateTime.to_iso8601(post1.published_at),
    #            "content" => post1.content,
    #            "author" => %{
    #              "id" => author1.id,
    #              "username" => author1.username
    #            },
    #            "comments" => [
    #              %{
    #                "id" => comment1.id,
    #                "content" => comment1.content,
    #                "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
    #                "reactions" => [],
    #                "author" => %{
    #                  "id" => current_user.id,
    #                  "username" => current_user.username
    #                },
    #                "replies" => [
    #                  %{
    #                    "id" => reply1.id,
    #                    "content" => reply1.content,
    #                    "comment_id" => comment1.id,
    #                    "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
    #                    "reactions" => [],
    #                    "author" => %{
    #                      "id" => author1.id,
    #                      "username" => author1.username
    #                    }
    #                  }
    #                ]
    #              },
    #              %{
    #                "id" => comment2.id,
    #                "content" => comment2.content,
    #                "inserted_at" => NaiveDateTime.to_iso8601(comment2.inserted_at),
    #                "reactions" => [],
    #                "author" => %{
    #                  "id" => author1.id,
    #                  "username" => author1.username
    #                },
    #                "replies" => []
    #              }
    #            ]
    #          }
    # end

    test "the post comments list starts with the comment by the user for whom the notifcation is generated",
         %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      # Other comments
      comment0 = ForumsFixtures.comment(post1, author1, %{content: "123"})
      comment00 = ForumsFixtures.comment(post1, author1, %{content: "1234"})

      # Comment by current user
      comment1 = ForumsFixtures.comment(post1, current_user, %{content: "abc"})

      # Reply that triggers notification and this 'show'.
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/posts/#{post1.id}/comments/#{comment1.id}")

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
                   "id" => comment0.id,
                   "content" => comment0.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment0.inserted_at),
                   "reactions" => [],
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "replies" => []
                 },
                 %{
                   "id" => comment00.id,
                   "content" => comment00.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(comment00.inserted_at),
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
end
