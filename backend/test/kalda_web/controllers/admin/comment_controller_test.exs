defmodule KaldaWeb.Admin.CommentControllerTest do
  use KaldaWeb.ConnCase

  describe "delete comment" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)

      conn = delete(conn, Routes.admin_post_comment_path(conn, :delete, post, comment))

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "delete comment as admin" do
    setup [:register_and_log_in_admin]

    test "deletes comment", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)
      comment = Kalda.ForumsFixtures.comment(post, user)
      forum = post.forum

      conn = delete(conn, Routes.admin_post_comment_path(conn, :delete, post, comment))

      assert redirected_to(conn) ==
               Routes.admin_post_path(conn, :index, forum)
    end
  end
end
