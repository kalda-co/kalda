defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  @doc """
  This 'show' shows the single post to the user when they click on a notification
  """

  def show(conn, %{"id" => id}) do
    post = Forums.get_post_order_preloads!(id)

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end

  @doc """
  The post that this notification id references is the parent post for a **comment-notification**!
  """
  def show_read(conn, %{"id" => notification_id}) do
    notification = Forums.get_notification!(notification_id, preload: [:comment])

    post = Forums.get_post_order_preloads!(notification.comment.post_id)

    # return post
    # update notification
    # front end refreshes notification

    Forums.update_notification!(notification, %{read: true})

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
