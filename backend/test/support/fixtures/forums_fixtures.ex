defmodule Kalda.ForumsFixtures do
  alias Kalda.Accounts.User
  alias Kalda.Forums.Post
  alias Kalda.Forums.Comment

  def unique_content, do: "Some content #{System.unique_integer()} here"

  def post(author = %User{}, attrs \\ %{}, forum \\ :daily_reflection) do
    defaults = %{
      content: unique_content()
    }

    # attrs override defaults
    attrs = Map.merge(defaults, attrs)

    {:ok, post} = Kalda.Forums.create_post(author, attrs, forum)
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

  def unmoderated_report(reporter = %User{}, content_type, p_c_r, attrs \\ %{}) do
    defaults = %{
      reporter_reason: "A good reason"
    }

    attrs = Map.merge(defaults, attrs)
    {:ok, report} = Kalda.Forums.report(reporter, content_type, p_c_r, attrs)
    report
  end
end
