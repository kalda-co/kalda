defmodule KaldaWeb.Api.V1.NotificationController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user

    # Currently gets only comment notifications implemented.
    # TODO do not show notifications for when user replies to own comment!
    notifications =
      Forums.get_notifications(user, preload: [comment: [:post], notification_reply: [:author]])

    # TODO: start a batched task here that will get 100 notifications for this user older than 20 days and set notification.expired == true

    conn
    |> render("index.json",
      user: user,
      notifications: notifications
    )
  end
end
