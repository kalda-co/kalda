defmodule Kalda.ForumsTest do
  use Kalda.DataCase

  alias Kalda.Forums
  alias Kalda.AccountsFixtures

  @valid_post_attrs %{content: "some content"}
  @update_post_attrs %{content: "some updated content"}
  @invalid_post_attrs %{content: ""}

  @valid_comment_attrs %{content: "some content"}
  @update_comment_attrs %{content: "some updated content"}
  @invalid_comment_attrs %{content: ""}

  @valid_reply_attrs %{content: "some reply"}
  @update_reply_attrs %{content: "some updated reply"}
  @invalid_reply_attrs %{content: ""}

  describe "posts" do
    alias Kalda.Forums.Post

    # def post_fixture(attrs \\ %{}) do
    #   {:ok, post} =
    #     attrs
    #     |> Enum.into(@valid_post_attrs)
    #     |> Forums.create_post()

    #   post
    # end

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

  describe "comments" do
    alias Kalda.Forums.Comment
    alias Kalda.Forums.Post
    alias Kalda.Forums

    test "get_comment!/1 gets the comment with the given id" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert Forums.get_comment!(comment.id) == comment
    end

    test "get_comments_for_post/1 gets all comments associated with given post" do
      user = AccountsFixtures.user_fixture()
      user2 = AccountsFixtures.user_fixture()
      user3 = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user2)
      assert {:ok, %Post{} = post2} = Forums.create_post(@valid_post_attrs, user2)
      assert {:ok, %Post{} = post3} = Forums.create_post(@valid_post_attrs, user3)

      assert {:ok, %Comment{} = comment1} =
               Forums.create_comment(user2, post3, @valid_comment_attrs)

      assert {:ok, %Comment{} = comment2} =
               Forums.create_comment(user3, post, @valid_comment_attrs)

      assert {:ok, %Comment{} = comment3} =
               Forums.create_comment(user, post3, @valid_comment_attrs)

      assert {:ok, %Comment{} = comment4} =
               Forums.create_comment(user, post3, @valid_comment_attrs)

      assert {:ok, %Comment{} = comment5} =
               Forums.create_comment(user, post2, @valid_comment_attrs)

      assert Forums.get_comments_for_post(post) == [comment2]
      assert Forums.get_comments_for_post(post2) == [comment5]

      id_list1 = Forums.get_comments_for_post(post3) |> Enum.map(& &1.id) |> Enum.sort()
      id_list2 = Enum.sort([comment1.id, comment3.id, comment4.id])

      assert id_list1 == id_list2
    end

    # TODO decide whether to have the (optional) attrs first or last in create comment and create post - needs to be consistent

    test "create_comment!/3 creates the comment for the given user and post" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:ok, %Comment{}} = Forums.create_comment(user, post, @valid_comment_attrs)
    end

    test "create_commennt/3 fails with invalid attrs" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)

      assert {:error, %Ecto.Changeset{}} =
               Forums.create_comment(user, post, @invalid_comment_attrs)
    end

    # TODO test with invalid user
    test "create_commennt/3 fails with invalid post" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      Forums.delete_post(post)

      assert {:error, %Ecto.Changeset{}} = Forums.create_comment(user, post, @valid_comment_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert comment.content == "some content"

      assert {:ok, %Comment{} = u_comment} = Forums.update_comment(comment, @update_comment_attrs)
      assert u_comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert comment.content == "some content"

      assert {:error, %Ecto.Changeset{}} = Forums.update_comment(comment, @invalid_comment_attrs)
      assert comment == Forums.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Comment{}} = Forums.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert %Ecto.Changeset{} = Forums.change_comment(comment)
    end
  end

  describe "replies" do
    alias Kalda.Forums.Comment
    alias Kalda.Forums.Post
    alias Kalda.Forums.Reply
    alias Kalda.Forums

    test "get_replies_for_comment/1 returns list of replies for comment" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert Forums.get_replies_for_comment(comment) == [reply]
    end

    test "get_reply!/1 gets the reply with the given id" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert Forums.get_reply!(reply.id) == reply
    end

    test "create_reply!/3 creates the reply for the given user and comment" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Reply{}} = Forums.create_reply(user, comment, @valid_reply_attrs)
    end

    test "create_commennt/3 fails with invalid attrs" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Forums.create_reply(user, comment, @invalid_reply_attrs)
    end

    # TODO test with invalid user
    test "create_reply/3 fails with invalid comment" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      Forums.delete_comment(comment)
      assert {:error, %Ecto.Changeset{}} = Forums.create_reply(user, comment, @valid_reply_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert reply.content == "some reply"

      assert {:ok, %Reply{} = u_reply} = Forums.update_reply(reply, @update_reply_attrs)
      assert u_reply.content == "some updated reply"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert reply.content == "some reply"

      assert {:error, %Ecto.Changeset{}} = Forums.update_reply(reply, @invalid_reply_attrs)
      assert reply == Forums.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert {:ok, %Reply{}} = Forums.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_post_attrs, user)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert %Ecto.Changeset{} = Forums.change_reply(reply)
    end
  end
end
