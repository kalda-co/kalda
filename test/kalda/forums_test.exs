defmodule Kalda.ForumsTest do
  use Kalda.DataCase

  alias Kalda.Forums

  describe "posts" do
    alias Kalda.Forums.Post

    @valid_post_attrs %{content: "some content"}
    @update_post_attrs %{content: "some updated content"}
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

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forums.change_post(post)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Forums.update_post(post, @update_post_attrs)
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forums.update_post(post, @invalid_post_attrs)
      assert post == Forums.get_post!(post.id)
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forums.get_post!(post.id) == post
    end
  end
end
