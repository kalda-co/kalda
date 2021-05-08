defmodule KaldaWeb.Api.V1.ReplyView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{reply: reply}) do
    render_reply(reply)
  end

  def render_reply(reply) do
    %{
      id: reply.id,
      content: reply.content,
      author: UserView.render_author(reply.author),
      comment_id: reply.comment_id,
      inserted_at: reply.inserted_at,
      reactions: []
    }
  end
end
