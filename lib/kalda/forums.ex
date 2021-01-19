defmodule Kalda.Forums do
  @moduledoc """
  The Forums context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo

  alias Kalda.Forums.Post

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns all posts.

  ## Examples

      iex> get_posts()
      [%Post{}, ...]

  """
  def get_posts do
    Repo.all(Post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
