defmodule KaldaWeb.Admin.ReplyController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_reply, Kalda)
    reply = Forums.get_reply!(id, preload: [comment: [:post]])
    forum = reply.comment.post.forum
    {:ok, _reply} = Forums.delete_reply(reply)

    conn
    |> put_flash(:info, "Reply deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index, forum))
  end
end
