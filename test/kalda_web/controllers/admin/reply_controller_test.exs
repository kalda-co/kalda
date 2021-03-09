defmodule KaldaWeb.Admin.ReplyControllerTest do
  use KaldaWeb.ConnCase

  describe "delete comment" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)

      conn =
        delete(conn, Routes.admin_post_comment_reply_path(conn, :delete, post, comment, reply))

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "delete comment as admin" do
    setup [:register_and_log_in_admin]

    test "deletes comment", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      reply = Kalda.ForumsFixtures.reply(comment, user)
      forum = post.forum

      conn =
        delete(conn, Routes.admin_post_comment_reply_path(conn, :delete, post, comment, reply))

      assert redirected_to(conn) ==
               Routes.admin_post_path(conn, :index, forum)
    end
  end
end
