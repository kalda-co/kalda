defmodule KaldaWeb.Api.V1.ReplyReactionController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.ReplyReaction

  def update(conn, %{"id" => reply_id} = reply_reaction_params) do
    user = conn.assigns.current_user
    reply = Forums.get_reply!(reply_id)

    with {:ok, %ReplyReaction{} = reply_reaction} <-
           Forums.insert_or_update_reply_reaction(user.id, reply.id, reply_reaction_params) do
      reply_reaction = reply_reaction |> Map.put(:author, user)

      conn
      |> put_status(201)
      |> render("show.json", reply_reaction: reply_reaction)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
