defmodule KaldaWeb.Admin.PostControllerTest do
  use KaldaWeb.ConnCase

  @create_willpool_attrs %{content: "This is a post", forum: :will_pool}
  @create_post_attrs %{content: "This is a post", forum: :community}
  @update_post_attrs %{content: "This is an updated post"}
  @schedule_post_attrs %{
    content: "This is a post",
    published_at: "2030-01-23T23:50:07"
  }
  @invalid_post_attrs %{content: ""}

  describe "index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :index, "daily-reflection"))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all posts if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :index, "daily_reflection"))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end

    test "recognises underscore route", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :index, "daily_reflection"))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end

    test "recognises hyphen route", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :index, "daily-reflection"))
      assert html_response(conn, 200) =~ "Daily Reflections"
    end

    test "recognises all forum routes", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :index, "will-pool"))
      assert html_response(conn, 200) =~ "Will Pools"

      conn = get(conn, Routes.admin_post_path(conn, :index, "Community"))
      assert html_response(conn, 200) =~ "Communitys"

      conn = get(conn, Routes.admin_post_path(conn, :index, "co_working"))
      assert html_response(conn, 200) =~ "Co Working"
    end

    test "shows post comments", %{conn: conn, user: _current_user} do
      user2 = Kalda.AccountsFixtures.admin()
      post = Kalda.ForumsFixtures.post(user2)
      _comment = Kalda.ForumsFixtures.comment(post, user2, %{content: "testing 123"})

      conn = get(conn, Routes.admin_post_path(conn, :index, "daily-reflection"))
      assert html_response(conn, 200) =~ "testing 123"
    end
  end

  describe "new post" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :new, "daily-reflection"))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_post_path(conn, :new, "daily-reflection"))
      assert html_response(conn, 200) =~ "New Daily Reflection"
    end
  end

  describe "create post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn = post(conn, Routes.admin_post_path(conn, :create), post: @create_post_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create post as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to index when data is valid and user is admin", %{conn: conn} do
      conn = post(conn, Routes.admin_post_path(conn, :create), post: @create_willpool_attrs)

      assert redirected_to(conn) == Routes.admin_post_path(conn, :index, :will_pool)

      conn = get(conn, Routes.admin_post_path(conn, :index, :will_pool))
      assert html_response(conn, 200) =~ "This is a post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_post_path(conn, :create), post: @invalid_post_attrs)

      response = html_response(conn, 200)
      assert response =~ "Please check the errors below"
    end
  end

  describe "edit post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)
      conn = get(conn, Routes.admin_post_path(conn, :edit, post))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "edit post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)
      conn = get(conn, Routes.admin_post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "schedule post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @schedule_post_attrs)
      conn = get(conn, Routes.admin_post_path(conn, :edit, post))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "schedule post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @schedule_post_attrs)
      conn = get(conn, Routes.admin_post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)

      conn = put(conn, Routes.admin_post_path(conn, :update, post), post: @update_post_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "update post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)

      conn = put(conn, Routes.admin_post_path(conn, :update, post), post: @update_post_attrs)

      assert redirected_to(conn) ==
               Routes.admin_post_path(conn, :show, post)

      conn = get(conn, Routes.admin_post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "This is an updated post"
    end
  end

  describe "delete post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)

      conn = delete(conn, Routes.admin_post_path(conn, :delete, post))

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "delete post as admin" do
    setup [:register_and_log_in_admin]

    test "deletes post", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user)
      forum = post.forum

      conn = delete(conn, Routes.admin_post_path(conn, :delete, post))

      assert redirected_to(conn) ==
               Routes.admin_post_path(conn, :index, forum)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_post_path(conn, :show, post))
      end
    end
  end
end
