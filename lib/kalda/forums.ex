defmodule Kalda.Forums do
  @moduledoc """
  The Forums context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo

  alias Kalda.Forums.Post
  alias Kalda.Forums.Comment

  @doc """
  Creates a post for a user

  ## Examples

      iex> create_post(user, %{field: value})
      {:ok, %Post{}}

      iex> create_post(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, attrs \\ %{}, forum \\ :daily_reflection) do
    %Post{author_id: user.id, forum: forum}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a daily_reflection for a user

  ## Examples

      iex> create_daily_reflection(user, %{field: value})
      {:ok, %Post{}}

      iex> create_daily_reflection(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_reflection(user, attrs \\ %{}) do
    create_post(user, attrs, :daily_reflection)
  end

  @doc """
  Returns all posts.

  ## Examples

      iex> get_posts(opts || [])
      [%Post{}, ...]

  """
  def get_posts(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from post in Post, preload: ^preload)
  end

  @doc """
  Returns all daily reflections except scheduled future ones
  Orders as most recently publised first

  ## Examples

      iex> get_daily_reflections(opts || [])
      [%Post{}, ...]
  """
  def get_daily_reflections() do
    now = NaiveDateTime.local_now()

    Repo.all(
      from post in Post,
        where: post.forum == :daily_reflection,
        where: post.published_at <= ^now,
        order_by: [desc: post.published_at],
        preload: [
          :author,
          comments:
            ^from(comment in Comment,
              order_by: [desc: comment.inserted_at],
              preload: [:author, replies: [:author]]
            )
        ]
    )
  end

  @doc """
  Return all posts that belong to the will_pool forum, along wth their
  associated comments and replies. Returns most recent post first

  ## Examples

    iex> get_will_pools()
    [%Post{}, ...]

  """
  def get_will_pools() do
    now = NaiveDateTime.local_now()

    Repo.all(
      from post in Post,
        where: post.forum == :will_pool,
        where: post.published_at <= ^now,
        order_by: [desc: post.published_at],
        preload: [
          :author,
          comments:
            ^from(comment in Comment,
              order_by: [desc: comment.inserted_at],
              preload: [:author, replies: [:author]]
            )
        ]
    )
  end

  @doc """
  Returns all daily reflections scheduled for the future
  Orders as soonest to be published first

  ## Examples

      iex> get_daily_reflections_scheduled(opts || [])
      [%Post{}, ...]
  """
  def get_daily_reflections_scheduled() do
    now = NaiveDateTime.local_now()

    Repo.all(
      from post in Post,
        where: post.forum == :daily_reflection,
        where: post.published_at > ^now,
        order_by: [asc: post.published_at]
      # preload: [
      #   :author,
      #   comments:
      #     ^from(comment in Comment,
      #       order_by: [desc: comment.inserted_at],
      #       preload: [:author, replies: [:author]]
      #     )
      # ]
    )
  end

  def get_forums_posts_limit(forum, limit) do
    Repo.all(
      from post in Post,
        where: post.forum == ^forum,
        order_by: [desc: post.inserted_at],
        limit: ^limit,
        preload: [
          :author,
          comments:
            ^from(comment in Comment,
              order_by: [desc: comment.inserted_at],
              preload: [:author, replies: [:author]]
            )
        ]
    )
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
  Returns an `%Ecto.Changeset{}` for tracking daily_reflection changes.

  ## Examples

      iex> change_daily_reflection(daily_reflection)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_daily_reflection(%Post{forum: :daily_reflection} = daily_reflection, attrs \\ %{}) do
    Post.changeset(daily_reflection, attrs)
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

      iex> get_post!(123, opts || [])
      %Post{}

      iex> get_post!(456), opts || []
      ** (Ecto.NoResultsError)

  """
  def get_post!(id, opts \\ []) do
    preload = opts[:preload] || []

    from(post in Post,
      where: post.id == ^id,
      preload: ^preload
    )
    |> Repo.get!(id)
  end

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
  Returns all comments.

  ## Examples

      iex> get_comments(opts || [])
      [%comment{}, ...]

  """
  def get_comments(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from comment in Comment, preload: ^preload)
  end

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

      iex> get_comment!(123, opts || [])
      %Comment{}

      iex> get_comment!(456), opts || []
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id, opts \\ []) do
    preload = opts[:preload] || []

    from(comment in Comment,
      where: comment.id == ^id,
      preload: ^preload
    )
    |> Repo.get!(id)
  end

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
  Returns all replies.
  ## Examples
      iex> get_replies(opts || [])
      [%reply{}, ...]
  """
  def get_replies(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from reply in Reply, preload: ^preload)
  end

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

  ##################
  # Reports
  ##################

  alias Kalda.Forums.Report

  @doc """
  Creates a report for a user(reporter) on a comment, post or reply

  ## Examples

      iex> report(reporter, "post", post, %{field: value})
      {:ok, %Report{}}

      iex> report(reporter, "", comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def report(reporter, content_type, post_comment_reply, attrs \\ %{}) do
    case content_type do
      "post" ->
        %Report{
          reported_content: post_comment_reply.content,
          author_id: post_comment_reply.author_id,
          post_id: post_comment_reply.id,
          reporter_id: reporter.id
        }
        |> Report.changeset(attrs)
        |> Repo.insert()

      "comment" ->
        %Report{
          reported_content: post_comment_reply.content,
          author_id: post_comment_reply.author_id,
          comment_id: post_comment_reply.id,
          reporter_id: reporter.id
        }
        |> Report.changeset(attrs)
        |> Repo.insert()

      "reply" ->
        %Report{
          reported_content: post_comment_reply.content,
          author_id: post_comment_reply.author_id,
          reply_id: post_comment_reply.id,
          reporter_id: reporter.id
        }
        |> Report.changeset(attrs)
        |> Repo.insert()
    end
  end

  def report_comment(reporter, comment, attrs \\ %{}) do
    report(reporter, "comment", comment, attrs)
  end

  def report_reply(reporter, reply, attrs \\ %{}) do
    report(reporter, "reply", reply, attrs)
  end

  @doc """
  Returns all reports.
  ## Examples
      iex> get_reports(opts || [])
      [%report{}, ...]
  """
  def get_reports(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from report in Report, preload: ^preload)
  end

  @doc """
  Returns all unresolved reports
  ## Examples
      iex> get_unresolved_reports(opts || [])
      [%report{}, ...]
  """
  def get_unresolved_reports(opts \\ []) do
    preload = opts[:preload] || []

    from(report in Report,
      where: is_nil(report.resolved_at),
      preload: ^preload
    )
    |> Repo.all()
  end

  @doc """
  Gets a single report.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_report!(123)
      [%Report{}, ...]

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id), do: Repo.get!(Report, id)

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.

  ## Examples

      iex> change_report(report)
      %Ecto.Changeset{data: %Report{}}

  """
  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.changeset(report, attrs)
  end
end
