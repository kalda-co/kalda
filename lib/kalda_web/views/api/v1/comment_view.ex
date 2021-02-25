defmodule KaldaWeb.Api.V1.CommentView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.ReplyView

  def render("show.json", %{comment: comment}) do
    render_comment(comment)
  end

  def render_comment(comment) do
    %{
      id: comment.id,
      content: comment.content,
      inserted_at: comment.inserted_at,
      author: UserView.render_author(comment.author),
      replies: Enum.map(comment.replies, &ReplyView.render_reply/1)
    }
  end

  # defp render_reply(reply) do
  #   %{
  #     id: reply.id,
  #     author: render_author(reply.author),
  #     content: reply.content,
  #     inserted_at: reply.inserted_at
  #   }
  # end

  # defp render_author(author) do
  #   %{
  #     id: author.id,
  #     username: author.username
  #   }
  # end
end
