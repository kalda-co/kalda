defmodule KaldaWeb.Api.V1.ReplyController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.Reply

  def create(conn, %{"id" => comment_id} = reply_params) do
    user = conn.assigns.current_user
    comment = Forums.get_comment!(comment_id)

    case Kalda.Accounts.has_subscription?(user) do
      true ->
        with {:ok, %Reply{} = reply} <- Forums.create_reply(user, comment, reply_params) do
          reply =
            reply
            |> Map.put(:author, user)
            |> Map.put(:reply_reactions, [])

          conn
          |> put_status(201)
          |> render("show_subscribed_author.json", reply: reply)
        end
        |> KaldaWeb.Api.V1.handle_error(conn)

      _ ->
        with {:ok, %Reply{} = reply} <- Forums.create_reply(user, comment, reply_params) do
          reply =
            reply
            |> Map.put(:author, user)
            |> Map.put(:reply_reactions, [])

          conn
          |> put_status(201)
          |> render("show_unsubscribed_author.json", reply: reply)
        end
        |> KaldaWeb.Api.V1.handle_error(conn)
    end
  end

  def show(conn, %{"id" => id}) do
    reply =
      Forums.get_reply!(id, preload: [:author, replies: [:author], reply_reactions: [:author]])

    case Kalda.Accounts.has_subscription?(reply.author) do
      true ->
        render(conn, "show_subscribed_author.json", reply: reply)

      _ ->
        render(conn, "show_unsubscribed_author.json", reply: reply)
    end
  end
end
