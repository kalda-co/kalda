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

    test "list notifications for user if a daily reflection is posted", %{
      conn: conn,
      user: current_user
    } do
      author1 = AccountsFixtures.user()

      post1 =
        ForumsFixtures.post(author1, %{
          published_at: NaiveDateTime.new!(~D[2020-01-01], ~T[00:00:00])
        })

      # TODO daily reflection posts should generate a notification to all users??

      conn = get(conn, "/v1/users/1/notifications")

      assert json_response(conn, 200) == %{
               "current_user" => %{
                 "id" => current_user.id,
                 "username" => current_user.username
               },
               "notifications" => [
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
                 }
               ]
             }
    end
  end
end
