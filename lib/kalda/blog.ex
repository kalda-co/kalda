defmodule Kalda.Blog do
  use NimblePublisher,
    build: Kalda.Blog.Post,
    from: "posts/**/**/*.md",
    as: :posts,
    highlighters: []

  defmodule NotFoundError do
    defexception [:message, plug_status: 404]
  end

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  @doc """
  Get all the blog posts.
  """
  def all_posts, do: @posts

  @doc """
  Get the post for a given id. Throws an exception if there is no post with
  that id.
  """
  def get_post_by_id!(id) do
    Enum.find(all_posts(), &(&1.id == id)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end

  @doc """
  Get all the tags that have been used in blog posts.
  """
  def all_tags, do: @tags

  def date_string(date) do
    # date = Date.from_iso8601!(attrs.date)
    day_num = Date.day_of_week(date)
    day_string = Elixir.Timex.day_name(day_num)
    month_string = Elixir.Timex.month_name(date.month)

    # "#{day_string}, #{date.day} #{month_string} #{date.year}."
    "#{day_string}, #{date.day} #{month_string}"
  end
end
