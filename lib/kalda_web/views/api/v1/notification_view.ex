defmodule KaldaWeb.Api.V1.NotificationView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("index.json", params) do
    %{
      current_user: UserView.render_author(params.user),
      notifications: Enum.map(params.notifications, &render_notification/1)
    }
  end

  defp render_notification(notification) do
    %{
      id: notification.id
    }
  end
end
