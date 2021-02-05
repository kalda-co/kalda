defmodule KaldaWeb.Api.V1.CommentView do
  use KaldaWeb, :view

  def render("show.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      author: comment.author_id,
      inserted_at: comment.inserted_at
    }
  end
end
