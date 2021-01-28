defmodule Kalda.ForumsFixtures do
  alias Kalda.Accounts.User
  alias Kalda.Forums.Post
  alias Kalda.Forums.Comment

  def unique_content, do: "Some content #{System.unique_integer()} here"

  def post(author = %User{}, attrs \\ %{}) do
    defaults = %{
      content: unique_content()
    }

    # attrs override defaults
    attrs = Map.merge(defaults, attrs)

    {:ok, post} = Kalda.Forums.create_post(author, attrs)
    post
  end

  def comment(post = %Post{}, author = %User{}, attrs \\ %{}) do
    defaults = %{
      content: unique_content()
    }

    attrs = Map.merge(defaults, attrs)
    {:ok, post} = Kalda.Forums.create_comment(author, post, attrs)
    post
  end

  def reply(comment = %Comment{}, author = %User{}, attrs \\ %{}) do
    defaults = %{
      content: unique_content()
    }

    attrs = Map.merge(defaults, attrs)
    {:ok, reply} = Kalda.Forums.create_reply(author, comment, attrs)
    reply
  end
end
