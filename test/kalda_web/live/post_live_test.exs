defmodule KaldaWeb.PostLiveTest do
  use KaldaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kalda.Forums

  @create_post_attrs %{content: "some content"}

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
  end
end
