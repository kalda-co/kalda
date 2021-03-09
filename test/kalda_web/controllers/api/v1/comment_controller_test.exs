defmodule KaldaWeb.Api.V1.CommentControllerTest do
  use KaldaWeb.ConnCase

  @valid_comment_content %{
    content: "This is a comment!"
  }
  @valid_long_comment_content %{
    content:
      "This is a comment that is really long. It definitely has well over 255 chars in it. It will probably go in the ginees book of records as the longest most pointless comment in the universe. Its favorite singer is probably Prince or maybe ray charles or maybe whitney housten or possibly otis redding with special shoutouts to Bill withers. Purple rain by prince is definitely its fave song, although that might be bc of that psychadelic experieence it had that time in the 70s."
  }
  too_long = String.duplicate("h", 5050)

  @invalid_long_comment_content %{
    content: too_long
  }
  @invalid_comment_content %{
    content: ""
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "unauthenticated requests" do
    test "POST create", ctx do
      assert ctx.conn |> post("/v1/posts/1/comments") |> json_response(401)
    end
  end

  describe "POST create" do
    setup [:register_and_log_in_user]

    test "renders 422 with errors for invalid attributes", %{conn: conn, user: _current_user} do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)
      assert conn = post(conn, "/v1/posts/#{post.id}/comments", @invalid_comment_content)

      assert json_response(conn, 422) == %{
               "errors" => %{"content" => ["can't be blank"]}
             }
    end

    test "creates comment for user on post in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)

      assert conn = post(conn, "/v1/posts/#{post.id}/comments", @valid_comment_content)

      # get_comments has no preloads
      assert [comment_no_preloads] = Kalda.Forums.get_comments()

      assert comment =
               Kalda.Forums.get_comment!(comment_no_preloads.id,
                 preload: [:author, replies: [:author]]
               )

      assert comment.content == @valid_comment_content.content
      assert comment.author_id == current_user.id
      assert comment.post_id == post.id

      assert json_response(conn, 201) == %{
               "id" => comment.id,
               "content" => @valid_comment_content.content,
               "author" => %{
                 "id" => comment.author_id,
                 "username" => comment.author.username
               },
               "inserted_at" => NaiveDateTime.to_iso8601(comment.inserted_at),
               "replies" => []
             }
    end

    test "creates longgggg comment for user on post in daily reflections", %{
      conn: conn,
      user: current_user
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)

      assert conn = post(conn, "/v1/posts/#{post.id}/comments", @valid_long_comment_content)

      # get_comments has no preloads
      assert [comment_no_preloads] = Kalda.Forums.get_comments()

      assert comment =
               Kalda.Forums.get_comment!(comment_no_preloads.id,
                 preload: [:author, replies: [:author]]
               )

      assert comment.content == @valid_long_comment_content.content
      assert comment.author_id == current_user.id
      assert comment.post_id == post.id

      assert json_response(conn, 201) == %{
               "id" => comment.id,
               "content" => @valid_long_comment_content.content,
               "author" => %{
                 "id" => comment.author_id,
                 "username" => comment.author.username
               },
               "inserted_at" => NaiveDateTime.to_iso8601(comment.inserted_at),
               "replies" => []
             }
    end

    test "doent create tooooooo longgggg comment for user on post in daily reflections", %{
      conn: conn
    } do
      user = Kalda.AccountsFixtures.user()
      post = Kalda.ForumsFixtures.post(user)

      assert conn = post(conn, "/v1/posts/#{post.id}/comments", @invalid_long_comment_content)

      assert json_response(conn, 422) == %{
               "errors" => %{"content" => ["should be at most 5000 character(s)"]}
             }
    end
  end
end
