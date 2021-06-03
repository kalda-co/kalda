defmodule KaldaWeb.Api.V1.NotificationController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    user = conn.assigns.current_user
    notifications = Forums.get_notifications(user)

    conn
    |> render("index.json",
      user: user,
      notifications: notifications
    )
  end
end
