defmodule KaldaWeb.Api.V1.PostControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET index" do
    test "lists all posts", %{conn: conn} do
      author1 = AccountsFixtures.user_fixture()
      author2 = AccountsFixtures.user_fixture()
      post1 = ForumsFixtures.post(author1)
      post2 = ForumsFixtures.post(author1)
      comment1 = ForumsFixtures.comment(post2, author2)
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/api/v1/posts")

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "id" => post1.id,
                   "inserted_at" => NaiveDateTime.to_iso8601(post1.inserted_at),
                   "content" => post1.content,
                   "author" => %{
                     "id" => author1.id,
                     "name" => "TODO change me to have a name"
                   },
                   "comments" => []
                 },
                 %{
                   "id" => post2.id,
                   "content" => post2.content,
                   "inserted_at" => NaiveDateTime.to_iso8601(post2.inserted_at),
                   "author" => %{
                     "id" => author1.id,
                     "name" => "TODO change me to have a name"
                   },
                   "comments" => [
                     %{
                       "id" => comment1.id,
                       "content" => comment1.content,
                       "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                       "author" => %{
                         "id" => author2.id,
                         "name" => "TODO change me to have a name"
                       },
                       "replies" => [
                         %{
                           "id" => reply1.id,
                           "content" => reply1.content,
                           "inserted_at" => NaiveDateTime.to_iso8601(comment1.inserted_at),
                           "author" => %{
                             "id" => author1.id,
                             "name" => "TODO change me to have a name"
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
