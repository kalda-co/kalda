defmodule KaldaWeb.Api.V1.DailyReflectionControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET index", ctx do
      assert ctx.conn |> get("/v1/daily-reflections") |> json_response(401)
    end
  end

  describe "GET index" do
    setup [:register_and_log_in_user]

    test "lists all posts", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()
      author2 = AccountsFixtures.user()
      post1 = ForumsFixtures.post(author1)
      post2 = ForumsFixtures.post(author1)
      comment1 = ForumsFixtures.comment(post2, author2)
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/daily-reflections")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "posts" => [
                 %{
                   "id" => post1.id,
                   "inserted_at" => NaiveDateTime.to_iso8601(post1.inserted_at),
                   "content" => post1.content,
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "comments" => []
                 },
                 %{
                   "id" => post2.id,
                   "content" => post2.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(post2.inserted_at),
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
