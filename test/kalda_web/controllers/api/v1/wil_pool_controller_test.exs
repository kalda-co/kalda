defmodule KaldaWeb.Api.V1.WillPoolControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET index", ctx do
      assert ctx.conn |> get("/v1/will-pools") |> json_response(401)
    end
  end

  describe "GET index" do
    setup [:register_and_log_in_user]

    test "lists all posts that are will pools", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()
      author2 = AccountsFixtures.user()

      # Future post - should not be returned
      _post =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2030-01-01], ~T[00:00:00])
        })

      _post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      post2 =
        ForumsFixtures.post(
          author1,
          %{
            published_at: NaiveDateTime.new!(~D[2018-01-01], ~T[00:00:00])
          },
          :will_pool
        )

      post3 = ForumsFixtures.post(author1, %{}, :will_pool)
      _post4 = ForumsFixtures.post(author1, %{}, :community)
      _post5 = ForumsFixtures.post(author1, %{}, :co_working)
      comment1 = ForumsFixtures.comment(post2, author2)
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/will-pools")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "posts" => [
                 %{
                   "forum" => "will_pool",
                   "id" => post3.id,
                   "published_at" => NaiveDateTime.to_iso8601(post3.published_at),
                   "content" => post3.content,
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "comments" => []
                 },
                 %{
                   "forum" => "will_pool",
                   "id" => post2.id,
                   "content" => post2.content,
                   "published_at" => NaiveDateTime.to_iso8601(post2.published_at),
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "comments" => [
                     %{
                       "id" => comment1.id,
                       "content" => comment1.content,
                       "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                       "author" => %{
                         "id" => author2.id,
                         "username" => author2.username
                       },
                       "replies" => [
                         %{
                           "id" => reply1.id,
                           "content" => reply1.content,
                           "comment_id" => comment1.id,
                           "inserted_at" => NaiveDateTime.to_iso8601(reply1.inserted_at),
                           "author" => %{
                             "id" => author1.id,
                             "username" => author1.username
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
