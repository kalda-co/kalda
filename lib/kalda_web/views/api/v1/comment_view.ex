defmodule KaldaWeb.Api.V1.CommentView do
  use KaldaWeb, :view

  def render("show.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      inserted_at: comment.inserted_at,
      author: %{
        id: comment.author.id,
        username: comment.author.username
      }
    }
  end
end
