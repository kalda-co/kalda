defmodule KaldaWeb.Admin.ForumControllerTest do
  use KaldaWeb.ConnCase

  # @create_post_attrs %{content: "This is a post"}
  # @invalid_post_attrs %{content: ""}

  describe "index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_forum_path(conn, :daily_reflection_index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all posts if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_forum_path(conn, :daily_reflection_index))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end
  end

  describe "new post" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_forum_path(conn, :daily_reflection_new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new daily reflection as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_forum_path(conn, :daily_reflection_new))
      assert html_response(conn, 200) =~ "New Daily Reflection"
    end
  end
end
