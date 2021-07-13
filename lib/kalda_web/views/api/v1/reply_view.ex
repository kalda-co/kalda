defmodule KaldaWeb.Api.V1.ReplyView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.ReplyReactionView

  def render("show_subscribed_author.json", %{reply: reply}) do
    render_reply_with_subscription(reply)
  end

  def render_reply_with_subscription(reply) do
    %{
      id: reply.id,
      content: reply.content,
      author: UserView.render_author_with_subscription(reply.author),
      comment_id: reply.comment_id,
      inserted_at: reply.inserted_at,
      reactions: Enum.map(reply.reply_reactions, &ReplyReactionView.render_reply_reaction/1)
    }
  end

  def render("show_unsubscribed_author.json", %{reply: reply}) do
    render_reply(reply)
  end

  def render_reply(reply) do
    %{
      id: reply.id,
      content: reply.content,
      author: UserView.render_author(reply.author),
      comment_id: reply.comment_id,
      inserted_at: reply.inserted_at,
      reactions: Enum.map(reply.reply_reactions, &ReplyReactionView.render_reply_reaction/1)
    }
  end
end
