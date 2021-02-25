defmodule KaldaWeb.Api.V1.DailyReflectionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.CommentView

  def render("index.json", params) do
    %{
      current_user: UserView.render_author(params.user),
      reflections: Enum.map(params.reflections, &render_post/1),
      pools: Enum.map(params.pools, &render_post/1)
    }
  end

  defp render_post(post) do
    %{
      id: post.id,
      author: UserView.render_author(post.author),
      content: post.content,
      comments: Enum.map(post.comments, &CommentView.render_comment/1),
      published_at: post.published_at,
      forum: post.forum
    }
  end
end
