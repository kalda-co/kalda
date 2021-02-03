defmodule KaldaWeb.AdminControllerTest do
  use KaldaWeb.ConnCase

  # alias Kalda.AccountsFixtures
  # alias Kalda.ForumsFixtures
  @create_post_attrs %{content: "This is a post"}
  @invalid_post_attrs %{content: ""}

  describe "user_index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :user_index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "user_index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all users if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :user_index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "post_index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :post_index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "post_index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all posts if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :post_index))
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :post_new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :post_new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :post_create), post: @create_post_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create post as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to show when data is valid and user is admin", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :post_create), post: @create_post_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_path(conn, :post_show, id)

      conn = get(conn, Routes.admin_path(conn, :post_show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :post_create), post: @invalid_post_attrs)
      response = html_response(conn, 200)
      assert response =~ "Please check the errors below"
    end
  end

  describe "edit post" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)
      conn = get(conn, Routes.admin_path(conn, :post_edit, post))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "edit post as admin" do
    setup [:register_and_log_in_admin]

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = Kalda.ForumsFixtures.post(user, @create_post_attrs)
      conn = get(conn, Routes.admin_path(conn, :post_edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  # TODO Tests for update and delete
end
