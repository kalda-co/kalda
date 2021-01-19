defmodule Kalda.ForumsTest do
  use Kalda.DataCase

  alias Kalda.Forums

  describe "posts" do
    alias Kalda.Forums.Post

    @valid_post_attrs %{content: "some content"}
    @invalid_post_attrs %{content: ""}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_post_attrs)
        |> Forums.create_post()

      post
    end

    test "create_post/1 with valid attrs" do
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs)
      assert post.content == "some content"
    end

    test "create_post/1 with invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Forums.create_post(@invalid_post_attrs)
    end

    test "get_posts/0 returns all posts" do
      post = post_fixture()
      assert Forums.get_posts() == [post]
    end
  end
end
