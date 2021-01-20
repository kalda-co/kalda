defmodule Kalda.ForumsTest do
  use Kalda.DataCase

  alias Kalda.Forums
  alias Kalda.AccountsFixtures

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
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert post.content == "some content"
    end

    test "create_post/1 with invalid attrs" do
      user = AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Forums.create_post(@invalid_post_attrs, user)
    end

    test "get_posts/0 returns all posts" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert Forums.get_posts() == [post]
    end

    test "change_post/1 returns a post changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert %Ecto.Changeset{} = Forums.change_post(post)
    end

    test "update_post/2 with valid data updates the post" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:ok, %Post{} = post} = Forums.update_post(post, @update_post_attrs)
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:error, %Ecto.Changeset{}} = Forums.update_post(post, @invalid_post_attrs)
      assert post == Forums.get_post!(post.id)
    end

    test "get_post!/1 returns the post with given id" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert Forums.get_post!(post.id) == post
    end

    test "delete_post/1 deletes the post" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:ok, %Post{}} = Forums.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_post!(post.id) end
    end
  end
end
