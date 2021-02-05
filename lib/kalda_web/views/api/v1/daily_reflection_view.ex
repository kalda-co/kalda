defmodule KaldaWeb.Api.V1.DailyReflectionView do
  use KaldaWeb, :view

  def render("index.json", params) do
    %{
      current_user: %{name: params.user.username},
      posts: Enum.map(params.posts, &render_post/1)
    }
  end

  defp render_post(post) do
    %{
      id: post.id,
      author: render_author(post.author),
      content: post.content,
      comments: Enum.map(post.comments, &render_comment/1),
      inserted_at: post.inserted_at
    }
  end

  defp render_author(author) do
    %{
      id: author.id,
      username: author.username
    }
  end

  defp render_comment(comment) do
    %{
      id: comment.id,
      author: render_author(comment.author),
      content: comment.content,
      inserted_at: comment.inserted_at,
      replies: Enum.map(comment.replies, &render_reply/1)
    }
  end

  defp render_reply(reply) do
    %{
      id: reply.id,
      author: render_author(reply.author),
      content: reply.content,
      inserted_at: reply.inserted_at
    }
  end
end
