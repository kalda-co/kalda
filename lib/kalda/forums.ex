defmodule Kalda.Forums do
  @moduledoc """
  The Forums context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo

  alias Kalda.Forums.Post
  alias Kalda.Forums.Comment
  alias Kalda.Forums.Reply

  @doc """
  Parses the forum from the route
  """
  def parse_forum!(params) do
    String.split(params, "-")
    |> Enum.join("_")
    |> String.downcase()
    |> String.to_existing_atom()
  end

  @doc """
  Turns a forum (atom enumtype) into a string for html

  ## Examples

      iex> name_string(:daily_reflection)
      "Daily Reflection"

  """
  def name_string(forum) do
    Atom.to_string(forum)
    |> String.split("_")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join(" ")
  end

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
  def get_posts_opts(opts \\ []) do
    preload = opts[:preload] || []
    Repo.all(from post in Post, preload: ^preload)
  end

  @doc """
  Returns all posts for forum, except scheduled future ones
  Orders as most recently publised first.
  Limit for number of records can be provided as an optional argument.
  :hide_comments can be provided as an optional argument

  ## Examples

      iex> get_posts(forum)
      [%Post{}, ...]

      iex> get_posts(forum, [limit: 2])
      [%Post{}, %Post{}]

      iex> get_posts(forum, [:hide_comments])
      [%Post{}, %Post{}... ]  # Where comments and replies, and their reactions are not retrieved
  """
  def get_posts(forum, opts \\ []) do
    now = NaiveDateTime.local_now()
    limit = opts[:limit] || 100

    comments_limit =
      if opts[:hide_comments] do
        0
      else
        100
      end

    Repo.all(
      from post in Post,
        where: post.forum == ^forum,
        where: post.published_at <= ^now,
        limit: ^limit,
        order_by: [desc: post.published_at],
        preload: [
          :author,
          comments:
            ^from(comment in Comment,
              limit: ^comments_limit,
              order_by: [desc: comment.inserted_at],
              preload: [
                :author,
                comment_reactions: [
                  :author
                ],
                replies:
                  ^from(reply in Reply,
                    order_by: [asc: reply.inserted_at],
                    preload: [
                      :author,
                      reply_reactions: [
                        :author
                      ]
                    ]
                  )
              ]
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

      iex> get_scheduled_posts(forum)
      [%Post{}, ...]
  """
  def get_scheduled_posts(forum) do
    now = NaiveDateTime.local_now()

    Repo.all(
      from post in Post,
        where: post.forum == ^forum,
        where: post.published_at > ^now,
        order_by: [asc: post.published_at],
        preload: [
          :author
        ]
    )
  end

  def get_forums_posts_limit(forum, limit) do
    now = NaiveDateTime.local_now()

    Repo.all(
      from post in Post,
        where: post.forum == ^forum,
        where: post.published_at <= ^now,
        order_by: [desc: post.published_at],
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
  def change_daily_reflection(%Post{} = daily_reflection, attrs \\ %{}) do
    daily_reflection
    |> Map.put(:forum, :daily_reflection)
    |> Post.changeset(attrs)
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
  Deletes a comment.
  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      ** (Ecto.NoResultsError)

  """
  def delete_comment!(id) do
    comment = get_comment!(id)
    Repo.delete!(comment)
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

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123, opts || [])
      %Reply{}

      iex> get_reply!(456), opts || []
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id, opts \\ []) do
    preload = opts[:preload] || []

    from(reply in Reply,
      where: reply.id == ^id,
      preload: ^preload
    )
    |> Repo.get!(id)
  end

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
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Deletes a reply.
  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Comment{}}

      iex> delete_reply(reply)
      ** (Ecto.NoResultsError)

  """
  def delete_reply!(id) do
    reply = get_reply!(id)
    Repo.delete!(reply)
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
  Returns all resolved reports
  ## Examples
      iex> get_resolved_reports(opts || [])
      [%report{}, ...]
  """
  def get_resolved_reports(opts \\ []) do
    preload = opts[:preload] || []

    from(report in Report,
      where: not is_nil(report.resolved_at),
      limit: 20,
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
  def get_report!(id, opts \\ []) do
    preload = opts[:preload] || []

    Repo.one!(
      from r in Report,
        where: r.id == ^id,
        preload: ^preload
    )
  end

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
  Moderates user-reported-content by updating a report. Attrs should contain the moderator id (current user) and the moderator reason.

  ## Examples

      iex> moderate_report(report, selection, mod_id, mod_reason)
      {:ok, %Report{}}

      iex> moderate_report(report, selection, mod_id, mod_reason)
      {:error, %Ecto.Changeset{}}

  """
  def moderate_report(report, moderator_action, mod_id, mod_reason) do
    {:ok, value} =
      Repo.transaction(fn ->
        changeset =
          Report.moderation_changeset(report, %{
            moderator_action: moderator_action,
            resolved_at: NaiveDateTime.local_now(),
            moderator_id: mod_id,
            moderator_reason: mod_reason
          })

        with {:ok, report} <- Repo.update(changeset) do
          if report.moderator_action == :delete do
            delete_reported_content!(report)
          end

          {:ok, report}
        end
      end)

    value
  end

  defp delete_reported_content!(report) do
    cond do
      report.comment_id -> delete_comment!(report.comment_id)
      report.post_id -> delete_post!(report.post_id)
      report.reply_id -> delete_reply!(report.reply_id)
    end
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

  @doc """
  Deletes a post.
  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> delete_post(post)
      {:ok, %Comment{}}

      iex> delete_post(post)
      ** (Ecto.NoResultsError)

  """
  def delete_post!(id) do
    post = get_post!(id)
    Repo.delete!(post)
  end

  alias Kalda.Forums.CommentReaction

  @doc """
  Returns the list of comment_reactions for comment.

  ## Examples

      iex> get_comment_reactions(comment)
      [%CommentReaction{}, ...]

  """

  def get_comment_reactions(comment, opts \\ []) do
    preload = opts[:preload] || []

    Repo.all(
      from comment_reaction in CommentReaction,
        where: comment_reaction.comment_id == ^comment.id,
        preload: ^preload
    )
  end

  @doc """
  Gets a single comment_reaction.

  Raises `Ecto.NoResultsError` if the CommentReaction does not exist.

  ## Examples

      iex> get_comment_reaction!(author_id, comment_id)
      %CommentReaction{}

      iex> get_comment_reaction!(123, 123)
      ** (Ecto.NoResultsError)

  """
  def get_comment_reaction!(author_id, comment_id),
    do: Repo.get_by!(CommentReaction, author_id: author_id, comment_id: comment_id)

  @doc """
  Creates a comment_reaction.

  ## Examples
      iex> create_comment_reaction(user, comment, %{field: value})
      {:ok, %CommentReaction{}}

      iex> create_comment_reaction(user, comment %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment_reaction(user_id, comment_id, attrs \\ %{}) do
    %CommentReaction{author_id: user_id, comment_id: comment_id}
    |> CommentReaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates or updates a comment_reaction.

  ## Examples

      iex> insert_or_update_comment_reaction(user, comment, %{field: value})
      {:ok, %CommentReaction{}}

      iex> insert_or_update_comment_reaction(user, comment %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_or_update_comment_reaction(author_id, comment_id, attrs \\ %{}) do
    reaction = Repo.get_by(CommentReaction, author_id: author_id, comment_id: comment_id)

    case reaction do
      nil -> create_comment_reaction(author_id, comment_id, attrs)
      reaction -> update_comment_reaction(reaction, attrs)
    end
  end

  @doc """
  Updates a comment_reaction.

  ## Examples

      iex> update_comment_reaction(comment_reaction, %{field: new_value})
      {:ok, %CommentReaction{}}

      iex> update_comment_reaction(comment_reaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment_reaction(%CommentReaction{} = comment_reaction, attrs) do
    comment_reaction
    |> CommentReaction.changeset(attrs)
    |> Repo.update()
  end

  alias Kalda.Forums.ReplyReaction

  @doc """
  Returns the list of reply_reactions for reply.

  ## Examples

      iex> get_reply_reactions(reply)
      [%ReplyReaction{}, ...]

  """

  def get_reply_reactions(reply, opts \\ []) do
    preload = opts[:preload] || []

    Repo.all(
      from reply_reaction in ReplyReaction,
        where: reply_reaction.reply_id == ^reply.id,
        preload: ^preload
    )
  end

  @doc """
  Gets a single reply_reaction.

  Raises `Ecto.NoResultsError` if the ReplyReaction does not exist.

  ## Examples

      iex> get_reply_reaction!(author_id, reply_id)
      %ReplyReaction{}

      iex> get_reply_reaction!(123, 123)
      ** (Ecto.NoResultsError)

  """
  def get_reply_reaction!(author_id, reply_id),
    do: Repo.get_by!(ReplyReaction, author_id: author_id, reply_id: reply_id)

  @doc """
  Creates a reply_reaction.

  ## Examples
      iex> create_reply_reaction(user, reply, %{field: value})
      {:ok, %ReplyReaction{}}

      iex> create_reply_reaction(user, reply %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply_reaction(user_id, reply_id, attrs \\ %{}) do
    %ReplyReaction{author_id: user_id, reply_id: reply_id}
    |> ReplyReaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates or updates a reply_reaction.

  ## Examples

      iex> insert_or_update_reply_reaction(user, reply, %{field: value})
      {:ok, %ReplyReaction{}}

      iex> insert_or_update_reply_reaction(user, reply %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_or_update_reply_reaction(author_id, reply_id, attrs \\ %{}) do
    reaction = Repo.get_by(ReplyReaction, author_id: author_id, reply_id: reply_id)

    case reaction do
      nil -> create_reply_reaction(author_id, reply_id, attrs)
      reaction -> update_reply_reaction(reaction, attrs)
    end
  end

  @doc """
  Updates a reply_reaction.

  ## Examples

      iex> update_reply_reaction(reply_reaction, %{field: new_value})
      {:ok, %ReplyReaction{}}

      iex> update_reply_reaction(reply_reaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply_reaction(%ReplyReaction{} = reply_reaction, attrs) do
    reply_reaction
    |> ReplyReaction.changeset(attrs)
    |> Repo.update()
  end

  # TODO Background job that deletes all rows for reply_reactions that have relate and send_love as both false. Perhaps 1x per day?
end
