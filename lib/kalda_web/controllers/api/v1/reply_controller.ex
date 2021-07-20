defmodule KaldaWeb.Api.V1.ReplyController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.Reply

  def create(conn, %{"id" => comment_id} = reply_params) do
    user = conn.assigns.current_user
    comment = Forums.get_comment!(comment_id)

    with {:ok, %Reply{} = reply} <- Forums.create_reply(user, comment, reply_params) do
      reply =
        reply
        |> Map.put(:author, user)
        |> Map.put(:reply_reactions, [])

      conn
      |> put_status(201)
      |> render("show.json", reply: reply)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
