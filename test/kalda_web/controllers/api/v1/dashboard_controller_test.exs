defmodule KaldaWeb.Api.V1.DashboardControllerTest do
  use KaldaWeb.ConnCase
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures
  alias Kalda.EventsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "GET index", ctx do
      assert ctx.conn |> get("/v1/dashboard") |> json_response(401)
    end
  end

  describe "GET index" do
    setup [:register_and_log_in_user]

    test "lists dashboard attributes", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()
      author2 = AccountsFixtures.user()
      therapy_session = EventsFixtures.future_therapy_session()
      # Future post - should not be returned

      _post =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2030-01-01], ~T[00:00:00])
        })

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      post2 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2018-01-01], ~T[00:00:00])
        })

      post3 = ForumsFixtures.post(author1, %{}, :will_pool)
      _post4 = ForumsFixtures.post(author1, %{}, :community)
      _post5 = ForumsFixtures.post(author1, %{}, :co_working)
      comment1 = ForumsFixtures.comment(post2, author2)
      reply1 = ForumsFixtures.reply(comment1, author1)
      conn = get(conn, "/v1/dashboard")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "next_therapy" => %{
                 "link" => therapy_session.link,
                 "id" => therapy_session.id,
                 "starts_at" => NaiveDateTime.to_iso8601(therapy_session.starts_at),
                 "title" => therapy_session.title,
                 "therapist" => therapy_session.therapist,
                 "credentials" => therapy_session.credentials,
                 "description" => therapy_session.description
               },
               "therapies" => [
                 %{
                   "link" => therapy_session.link,
                   "id" => therapy_session.id,
                   "starts_at" => NaiveDateTime.to_iso8601(therapy_session.starts_at),
                   "title" => therapy_session.title,
                   "therapist" => therapy_session.therapist,
                   "credentials" => therapy_session.credentials,
                   "description" => therapy_session.description
                 }
               ],
               "reflections" => [
                 %{
                   "forum" => "daily_reflection",
                   "id" => post1.id,
                   "published_at" => NaiveDateTime.to_iso8601(post1.published_at),
                   "content" => post1.content,
                   "author" => %{
                     "id" => author1.id,
                     "username" => author1.username
                   },
                   "comments" => []
                 },
                 %{
                   "forum" => "daily_reflection",
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
               ],
               "pools" => [
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
                 }
               ]
             }
    end

    test "lists dashboard attributes when therapy session nil", %{conn: conn, user: current_user} do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(
          author1,
          %{
            published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
          },
          :daily_reflection
        )

      post3 = ForumsFixtures.post(author1, %{}, :will_pool)
      comment1 = ForumsFixtures.comment(post1, author1)
      reply1 = ForumsFixtures.reply(comment1, author1)

      conn = get(conn, "/v1/dashboard")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "next_therapy" => nil,
               "therapies" => [],
               "reflections" => [
                 %{
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
                       "author" => %{
                         "id" => author1.id,
                         "username" => author1.username
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
               ],
               "pools" => [
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
                 }
               ]
             }
    end

    test "limits posts to 10 or less", %{conn: conn, user: _current_user} do
      user = AccountsFixtures.user()
      _post = ForumsFixtures.post(user)
      _post1 = ForumsFixtures.post(user)
      _post2 = ForumsFixtures.post(user)
      _post3 = ForumsFixtures.post(user)
      _post4 = ForumsFixtures.post(user)
      _post5 = ForumsFixtures.post(user)
      _post6 = ForumsFixtures.post(user)
      _post7 = ForumsFixtures.post(user)
      _post8 = ForumsFixtures.post(user)
      _post9 = ForumsFixtures.post(user)
      _post10 = ForumsFixtures.post(user)
      _post11 = ForumsFixtures.post(user)
      _post12 = ForumsFixtures.post(user)

      conn = get(conn, "/v1/dashboard")

      assert response = json_response(conn, 200)
      posts = response["reflections"]

      assert length(posts) == 10
    end
  end
end
