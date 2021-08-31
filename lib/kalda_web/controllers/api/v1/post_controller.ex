defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  @doc """
  'Old' show - remains to preserve API
  This 'show' shows the single post to the user when they click on a notification
  """

  def show(conn, %{"id" => id}) do
    post = Forums.get_post_order_preloads!(id)
    # Update notification as read
    # Put n_id in route
    # update n.

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end

  @doc """
  This 'show' shows the single post to the user when they click on a notification
  """

  # TODO: test
  def show_notification_post_comment(conn, %{"notification_id" => notification_id}) do
    notification =
      Forums.get_notification!(notification_id,
        preload: [:comment, [:author, post: [:author, replies: [:author]]]]
      )

    IO.inspect(notification.comment.post_id)

    post = Forums.get_post_order_preloads!(notification.comment.post_id)
    # Update notification as read
    # Put n_id in route
    # update n.

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
