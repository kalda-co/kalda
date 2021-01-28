defmodule KaldaWeb.PostLiveTest do
  use KaldaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kalda.AccountsFixtures
  alias Kalda.ForumsFixtures
  alias Kalda

  @create_post_attrs %{content: "some content"}
  @update_post_attrs %{content: "some updated content"}
  @invalid_post_attrs %{content: nil}

  describe "Index" do
    setup [:register_and_log_in_user]

    test "lists all posts", %{conn: conn} do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      {:ok, _index_live, html} = live(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Daily Reflections"
      assert html =~ post.content
    end

    test "saves new post", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(index_live, Routes.post_index_path(conn, :new))

      assert index_live
             |> form("#post-form", post: @invalid_post_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post-form", post: @create_post_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Post created successfully"
      assert html =~ "some content"
    end

    test "updates post in listing", %{conn: conn} do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("#post-#{post.id} a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(index_live, Routes.post_index_path(conn, :edit, post))

      assert index_live
             |> form("#post-form", post: @invalid_post_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post-form", post: @update_post_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Post updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes post in listing", %{conn: conn} do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("#post-#{post.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post-#{post.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user]

    test "displays post", %{conn: conn} do
      # admin = AccountsFixtures.admin()
      # user0 = AccountsFixtures.user()
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)
      # post2 = ForumFixtures.post(admin)
      # comment1 = ForumFixtures.comment(post, user1)

      {:ok, _show_live, html} = live(conn, Routes.post_show_path(conn, :show, post))

      assert html =~ "Show Post"
      assert html =~ post.content
    end

    test "updates post within modal", %{conn: conn} do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      {:ok, show_live, _html} = live(conn, Routes.post_show_path(conn, :show, post))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(show_live, Routes.post_show_path(conn, :edit, post))

      assert show_live
             |> form("#post-form", post: @invalid_post_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#post-form", post: @update_post_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_show_path(conn, :show, post))

      assert html =~ "Post updated successfully"
      assert html =~ "some updated content"
    end
  end
end
