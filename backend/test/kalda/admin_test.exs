defmodule Kalda.AdminTest do
  use Kalda.DataCase

  alias Kalda.Admin
  alias Kalda.Forums
  alias Kalda.ForumsFixtures
  alias Kalda.AccountsFixtures

  test "posts get archived automatically" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    Forums.delete_post(post)
    assert [archived] = Admin.list_archived()
    assert archived.table == "posts"

    assert archived.data == %{
             "id" => post.id,
             "forum" => to_string(post.forum),
             "content" => post.content,
             "author_id" => user.id,
             "updated_at" => NaiveDateTime.to_iso8601(post.updated_at),
             "inserted_at" => NaiveDateTime.to_iso8601(post.inserted_at),
             "published_at" => NaiveDateTime.to_iso8601(post.published_at)
           }
  end

  test "comments get archived automatically" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    comment = ForumsFixtures.comment(post, user)
    Forums.delete_comment(comment)
    assert [archived] = Admin.list_archived()
    assert archived.table == "comments"

    assert archived.data == %{
             "id" => comment.id,
             "content" => comment.content,
             "post_id" => post.id,
             "author_id" => user.id,
             "updated_at" => NaiveDateTime.to_iso8601(comment.updated_at),
             "inserted_at" => NaiveDateTime.to_iso8601(comment.inserted_at)
           }
  end

  test "replies get archived automatically" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    comment = ForumsFixtures.comment(post, user)
    reply = ForumsFixtures.reply(comment, user)
    Forums.delete_reply(reply)
    assert [archived] = Admin.list_archived()
    assert archived.table == "replies"

    assert archived.data == %{
             "id" => reply.id,
             "content" => reply.content,
             "comment_id" => comment.id,
             "author_id" => user.id,
             "updated_at" => NaiveDateTime.to_iso8601(reply.updated_at),
             "inserted_at" => NaiveDateTime.to_iso8601(reply.inserted_at)
           }
  end

  test "deleting a post deletes associated comments and replies" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    comment = ForumsFixtures.comment(post, user)
    _reply = ForumsFixtures.reply(comment, user)
    Forums.delete_post(post)
    assert [_archived, _archived_comment, _archived_reply] = Admin.list_archived()
  end

  test "deleting a comment deletes associated replies" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    comment = ForumsFixtures.comment(post, user)
    _reply = ForumsFixtures.reply(comment, user)
    Forums.delete_comment(comment)
    assert [_archived_comment, _archived_reply] = Admin.list_archived()
  end

  test "deleting a reply" do
    user = AccountsFixtures.user()
    post = ForumsFixtures.post(user)
    comment = ForumsFixtures.comment(post, user)
    reply = ForumsFixtures.reply(comment, user)
    Forums.delete_reply(reply)
    refute [] == Admin.list_archived()
    assert [_archived_reply] = Admin.list_archived()
  end
end
