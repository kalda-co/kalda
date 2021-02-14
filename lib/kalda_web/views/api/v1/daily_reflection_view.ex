defmodule KaldaWeb.Api.V1.DailyReflectionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.ReplyView

  def render("index.json", params) do
    %{
      current_user: UserView.render_author(params.user),
      posts: Enum.map(params.posts, &render_post/1)
    }
  end

  defp render_post(post) do
    %{
      id: post.id,
      author: UserView.render_author(post.author),
      content: post.content,
      comments: Enum.map(post.comments, &render_comment/1),
      inserted_at: post.inserted_at
    }
  end

  defp render_comment(comment) do
    %{
      id: comment.id,
      author: UserView.render_author(comment.author),
      content: comment.content,
      inserted_at: comment.inserted_at,
      replies: Enum.map(comment.replies, &ReplyView.render_reply/1)
    }
  end
end
