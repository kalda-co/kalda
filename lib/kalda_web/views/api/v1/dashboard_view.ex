defmodule KaldaWeb.Api.V1.DashboardView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.CommentView
  alias KaldaWeb.Api.V1.TherapyView
  alias KaldaWeb.Api.V1.NotificationView

  def render("index.json", params) do
    %{
      current_user: UserView.render_user(params.user),
      reflections: Enum.map(params.reflections, &render_post/1),
      pools: Enum.map(params.pools, &render_post/1),
      next_therapy: TherapyView.render_therapy_session(params.next_therapy),
      therapies: Enum.map(params.therapies, &TherapyView.render_therapy_session/1),
      comment_notifications:
        Enum.map(
          params.comment_notifications,
          &NotificationView.render_comment_notification/1
        )
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
