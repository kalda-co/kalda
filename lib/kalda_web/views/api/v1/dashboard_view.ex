defmodule KaldaWeb.Api.V1.DashboardView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.CommentView
  alias KaldaWeb.Api.V1.TherapyView

  def render("index_with_subscription.json", params) do
    %{
      current_user: UserView.render_author_with_subscription(params.user),
      reflections: Enum.map(params.reflections, &render_post/1),
      pools: Enum.map(params.pools, &render_post/1),
      next_therapy: TherapyView.render_therapy_session(params.next_therapy),
      therapies: Enum.map(params.therapies, &TherapyView.render_therapy_session/1)
    }
  end

  # TODO: is there a security issue here in that the api still sends the comment and reply data and it is just not viewable?
  def render("index_no_subscription.json", params) do
    %{
      current_user: UserView.render_author(params.user),
      # reflections: Enum.map(params.reflections, &render_post_without_comments/1),
      # pools: [],
      # next_therapy: TherapyView.render_therapy_session(params.next_therapy),
      reflections: Enum.map(params.reflections, &render_post/1),
      pools: Enum.map(params.pools, &render_post/1),
      next_therapy: TherapyView.render_therapy_session(params.next_therapy),
      therapies: []
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

  defp render_post_without_comments(post) do
    %{
      id: post.id,
      author: UserView.render_author(post.author),
      content: post.content,
      comments: [],
      published_at: post.published_at,
      forum: post.forum
    }
  end
end
