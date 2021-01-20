defmodule Kalda.ForumsFixtures do
  alias Kalda.Accounts.User
  # alias Kalda.Forums.Post

  def unique_content, do: "Some content #{System.unique_integer()} here"

  def post(author = %User{}, attrs \\ %{}) do
    defaults = %{
      content: unique_content()
    }

    # attrs override defaults
    attrs = Map.merge(defaults, attrs)

    {:ok, post} = Kalda.Forums.create_post(attrs, author)
    post
  end

  # def comment(post = %Post{}, author = %User{}, attrs \\ %{}) do
  #   defaults = %{
  #     content: unique_content()
  #   }

  #   attrs = Map.merge(defaults, attrs)
  #   {:ok, post} = Kalda.Forums.create_comment(attrs, author, post)
  #   post
  # end
end
