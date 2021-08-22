defmodule KaldaWeb.Api.V1.DashboardController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Events

  def index(conn, _params) do
    user = conn.assigns.current_user

    reflections =
      Forums.get_posts(:daily_reflection,
        limit: 10,
        # if user has_subscription(true) we do NOT want to hide comments
        hide_comments: !Kalda.Accounts.has_subscription?(user)
      )

    pools =
      Forums.get_posts(:will_pool,
        limit: 10,
        hide_comments: !Kalda.Accounts.has_subscription?(user)
      )

    next_therapy = Events.get_next_therapy_session!()

    therapies = Events.get_therapy_sessions(limit: 10)

    therapies_subscribed? =
      case Kalda.Accounts.has_subscription?(user) do
        true -> therapies
        _ -> therapies |> Enum.map(fn therapy -> %{therapy | link: ""} end)
      end

    comment_notifications =
      Forums.get_notifications(user, preload: [:comment, notification_reply: [:author]])

    conn
    |> render("index.json",
      user: user,
      reflections: reflections,
      pools: pools,
      next_therapy: next_therapy,
      therapies: therapies_subscribed?,
      comment_notifications: comment_notifications
    )
  end
end
