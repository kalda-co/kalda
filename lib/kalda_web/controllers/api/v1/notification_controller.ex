defmodule KaldaWeb.Api.V1.NotificationController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user

    # Currently gets only comment notifications implemented.
    # The notification_reply cannot be accessed through the comment because there may be multiple replies per comment
    notifications =
      Forums.get_notifications(user, preload: [:comment, notification_reply: [:author]])

    conn
    |> render("index.json",
      user: user,
      notifications: notifications
    )
  end
end
