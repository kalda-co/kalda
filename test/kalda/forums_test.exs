defmodule Kalda.ForumsTest do
  use Kalda.DataCase

  alias Kalda.Forums
  alias Kalda.AccountsFixtures
  alias Kalda.ForumsFixtures

  @valid_post_attrs %{content: "some content"}
  @update_post_attrs %{content: "some updated content"}
  @invalid_post_attrs %{content: ""}

  @valid_comment_attrs %{content: "some content"}
  @update_comment_attrs %{content: "some updated content"}
  @invalid_comment_attrs %{content: ""}

  @valid_reply_attrs %{content: "some reply"}
  @update_reply_attrs %{content: "some updated reply"}
  @invalid_reply_attrs %{content: ""}

  @valid_reporter_reason %{reporter_reason: "This is inappropriate"}
  @invalid_reporter_reason %{reporter_reason: ""}

  describe "posts" do
    alias Kalda.Forums.Post

    test "create_post/1 with valid attrs" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert post.content == "some content"
    end

    test "create_post/1 with invalid attrs" do
      user = AccountsFixtures.user()
      assert {:error, %Ecto.Changeset{}} = Forums.create_post(user, @invalid_post_attrs)
    end

    test "get_posts/0 returns all posts" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert Forums.get_posts() == [post]
    end

    test "get_daily_reflections" do
      now = NaiveDateTime.local_now()
      user1 = AccountsFixtures.user()
      user2 = AccountsFixtures.user()
      post1 = ForumsFixtures.post(user1)
      post2 = ForumsFixtures.post(user1)
      post3 = ForumsFixtures.post(user2)
      comment1 = ForumsFixtures.comment(post1, user2)
      comment2 = ForumsFixtures.comment(post2, user1)
      comment3 = ForumsFixtures.comment(post2, user1)
      reply1 = ForumsFixtures.reply(comment1, user2)
      reply2 = ForumsFixtures.reply(comment1, user2)
      reply3 = ForumsFixtures.reply(comment2, user2)

      set_inserted_at = fn thing, time ->
        Repo.update_all(
          from(r in thing.__struct__, where: r.id == ^thing.id),
          set: [inserted_at: time]
        )
      end

      set_inserted_at.(post1, NaiveDateTime.add(now, -100))
      set_inserted_at.(post2, NaiveDateTime.add(now, -90))
      set_inserted_at.(post3, NaiveDateTime.add(now, -80))
      set_inserted_at.(comment1, NaiveDateTime.add(now, -96))
      set_inserted_at.(comment2, NaiveDateTime.add(now, -85))
      set_inserted_at.(comment3, NaiveDateTime.add(now, -75))
      set_inserted_at.(reply1, NaiveDateTime.add(now, -80))
      set_inserted_at.(reply2, NaiveDateTime.add(now, -70))
      set_inserted_at.(reply3, NaiveDateTime.add(now, -60))

      result =
        Forums.get_daily_reflections()
        |> Enum.map(fn post ->
          %{
            id: post.id,
            comments:
              Enum.map(post.comments, fn comment ->
                replies = Enum.map(comment.replies, fn reply -> %{id: reply.id} end)
                %{id: comment.id, replies: replies}
              end)
          }
        end)

      assert result == [
               %{id: post3.id, comments: []},
               %{
                 id: post2.id,
                 comments: [
                   %{id: comment3.id, replies: []},
                   %{id: comment2.id, replies: [%{id: reply3.id}]}
                 ]
               },
               %{
                 id: post1.id,
                 comments: [
                   %{
                     id: comment1.id,
                     replies: [
                       %{id: reply1.id},
                       %{id: reply2.id}
                     ]
                   }
                 ]
               }
             ]
    end

    test "change_post/1 returns a post changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert %Ecto.Changeset{} = Forums.change_post(post)
    end

    test "update_post/2 with valid data updates the post" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:ok, %Post{} = post} = Forums.update_post(post, @update_post_attrs)
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:error, %Ecto.Changeset{}} = Forums.update_post(post, @invalid_post_attrs)
      assert post == Forums.get_post!(post.id)
    end

    test "get_post!/1 returns the post with given id" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert Forums.get_post!(post.id) == post
    end

    test "delete_post/1 deletes the post" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:ok, %Post{}} = Forums.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_post!(post.id) end
    end
  end

  describe "comments" do
    alias Kalda.Forums.Comment
    alias Kalda.Forums.Post
    alias Kalda.Forums

    test "get_comment!/1 gets the comment with the given id" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert Forums.get_comment!(comment.id) == comment
      # Test of preloads
      comment_with_preloads =
        Forums.get_comment!(comment.id, preload: [:author, replies: [:author]])

      assert comment_with_preloads.author.id == user.id
    end

    test "get_comments_for_post/1 gets all comments associated with given post" do
      user = AccountsFixtures.user()
      user2 = AccountsFixtures.user()
      user3 = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Post{} = post2} = Forums.create_post(user2, @valid_post_attrs)
      assert {:ok, %Post{} = post3} = Forums.create_post(user3, @valid_post_attrs)

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

    test "create_comment!/3 creates the comment for the given user and post" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:ok, %Comment{}} = Forums.create_comment(user, post, @valid_comment_attrs)
    end

    test "create_commennt/3 fails with invalid attrs" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Forums.create_comment(user, post, @invalid_comment_attrs)
    end

    test "create_commennt/3 fails with invalid post" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      Forums.delete_post(post)

      assert {:error, %Ecto.Changeset{}} = Forums.create_comment(user, post, @valid_comment_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert comment.content == "some content"

      assert {:ok, %Comment{} = u_comment} = Forums.update_comment(comment, @update_comment_attrs)
      assert u_comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert comment.content == "some content"

      assert {:error, %Ecto.Changeset{}} = Forums.update_comment(comment, @invalid_comment_attrs)
      assert comment == Forums.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Comment{}} = Forums.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
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
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert Forums.get_replies_for_comment(comment) == [reply]
    end

    test "get_reply!/1 gets the reply with the given id" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert Forums.get_reply!(reply.id) == reply
    end

    test "create_reply!/3 creates the reply for the given user and comment" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:ok, %Reply{}} = Forums.create_reply(user, comment, @valid_reply_attrs)
    end

    test "create_commennt/3 fails with invalid attrs" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Forums.create_reply(user, comment, @invalid_reply_attrs)
    end

    test "create_reply/3 fails with invalid comment" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)

      Forums.delete_comment(comment)
      assert {:error, %Ecto.Changeset{}} = Forums.create_reply(user, comment, @valid_reply_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert reply.content == "some reply"

      assert {:ok, %Reply{} = u_reply} = Forums.update_reply(reply, @update_reply_attrs)
      assert u_reply.content == "some updated reply"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)
      assert reply.content == "some reply"

      assert {:error, %Ecto.Changeset{}} = Forums.update_reply(reply, @invalid_reply_attrs)
      assert reply == Forums.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert {:ok, %Reply{}} = Forums.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a changeset" do
      user = AccountsFixtures.user()
      assert {:ok, %Post{} = post} = Forums.create_post(user, @valid_post_attrs)
      assert {:ok, %Comment{} = comment} = Forums.create_comment(user, post, @valid_comment_attrs)
      assert {:ok, %Reply{} = reply} = Forums.create_reply(user, comment, @valid_reply_attrs)

      assert %Ecto.Changeset{} = Forums.change_reply(reply)
    end
  end

  describe "reports" do
    alias Kalda.Forums.Report

    test "report/4 with valid attrs" do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      reporter = AccountsFixtures.user()
      content_type = "post"

      assert {:ok, %Report{} = report} =
               Forums.report(reporter, content_type, post, @valid_reporter_reason)

      assert report.reporter_id == reporter.id
      assert report.reporter_reason == "This is inappropriate"
      assert report.author_id == user.id
    end

    test "report/4 does not create report of no reason given(invalid attrs)" do
      user = AccountsFixtures.user()
      post = ForumsFixtures.post(user)

      reporter = AccountsFixtures.user()
      content_type = "post"

      assert {:error, %Ecto.Changeset{}} =
               Forums.report(reporter, content_type, post, @invalid_reporter_reason)
    end

    # TODO: test report_comment

    # TODO: test doesn't get resolved reports!
    test "get_unresolved_reports/1" do
      user = AccountsFixtures.user()
      user2 = AccountsFixtures.user()
      user3 = AccountsFixtures.user()
      post = ForumsFixtures.post(user)
      _post2 = ForumsFixtures.post(user2)
      comment = ForumsFixtures.comment(post, user2)

      reporter = user3
      reporter2 = user2

      assert {:ok, %Report{} = report} =
               Forums.report_comment(reporter, comment, @valid_reporter_reason)

      assert {:ok, %Report{} = report2} =
               Forums.report(reporter2, "post", post, @valid_reporter_reason)

      id_list1 = Forums.get_unresolved_reports() |> Enum.map(& &1.id) |> Enum.sort()
      id_list2 = Enum.sort([report.id, report2.id])

      assert id_list1 == id_list2
    end
  end
end
