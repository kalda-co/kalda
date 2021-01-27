defmodule Kalda.Forums do
  @moduledoc """
  The Forums context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo

  alias Kalda.Forums.Post

  @doc """
  Creates a post for a user

  ## Examples

      iex> create_post(%{user, field: value})
      {:ok, %Post{}}

      iex> create_post(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, attrs \\ %{}) do
    %Post{author_id: user.id}
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

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  ##################
  #
  #
  #
  #
  #
  #
  #
  #
  # Comments
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  ##################

  alias Kalda.Forums.Comment

  @doc """
  Returns the list of comments for a post.

  ## Examples

      iex> get_comments_for_post(post)
      [%Comment{}, ...]

  """
  # TODO Preloads as options
  def get_comments_for_post(post) do
    from(comment in Comment,
      where: comment.post_id == ^post.id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment for a user in a post

  ## Examples

      iex> create_comment(user, post, %{field: value})
      {:ok, %Comment{}}

      iex> create_comment(user, post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(user, post, attrs \\ %{}) do
    %Comment{author_id: user.id, post_id: post.id}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  ##################
  #
  #
  #
  #
  #
  #
  #
  # Replies
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  ##################

  alias Kalda.Forums.Reply

  @doc """
  Returns the list of replies for a comment.

  ## Examples

      iex> get_replies_for_comment(comment)
      [%Comment{}, ...]

  """
  # TODO Preloads as options
  def get_replies_for_comment(comment) do
    from(reply in Reply,
      where: reply.comment_id == ^comment.id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_reply!(123)
      [%Reply{}, ...]

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Creates a reply for a user in a comment

  ## Examples

      iex> create_reply(user, comment, %{field: value})
      {:ok, %Reply{}}

      iex> create_reply(user, comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(user, comment, attrs \\ %{}) do
    %Reply{author_id: user.id, comment_id: comment.id}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reply.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  # TODO Implement 'soft' delete so record preserved
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{data: %Reply{}}

  """
  def change_reply(%Reply{} = reply, attrs \\ %{}) do
    Reply.changeset(reply, attrs)
  end
end
