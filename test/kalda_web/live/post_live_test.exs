defmodule KaldaWeb.PostLiveTest do
  use KaldaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kalda.Forums

  @create_post_attrs %{content: "some content"}
  # @update_post_attrs %{content: "some updated content"}
  @invalid_post_attrs %{content: nil}

  defp fixture(:post) do
    {:ok, post} = Forums.create_post(@create_post_attrs)
    post
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end

  describe "Index" do
    setup [:create_post]

    test "lists all posts", %{conn: conn, post: post} do
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
  end
end
