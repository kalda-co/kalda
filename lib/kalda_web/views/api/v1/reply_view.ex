defmodule KaldaWeb.Api.V1.ReplyView do
  use KaldaWeb, :view

  def render("show.json", %{reply: reply}) do
    %{
      id: reply.id,
      content: reply.content,
      author: reply.author_id,
      comment_id: reply.comment_id,
      inserted_at: reply.inserted_at
    }
  end
end
