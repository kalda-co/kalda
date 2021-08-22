defmodule KaldaWeb.Api.V1.NotificationView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("index.json", params) do
    %{
      current_user: UserView.render_author(params.user),
      notifications: %{
        comment_notifications: Enum.map(params.notifications, &render_comment_notification/1),
        post_notifications: nil
      }
    }
  end

  def render_comment_notification(notification) do
    %{
      # Cannot currently access notification id
      # id: notification.id,
      comment_id: notification.comment_id,
      comment_content: notification.comment.content,
      notification_reply_id: notification.notification_reply.id,
      reply_content: notification.notification_reply.content,
      reply_author: UserView.render_author(notification.notification_reply.author),
      inserted_at: notification.notification_reply.inserted_at
    }
  end
end
