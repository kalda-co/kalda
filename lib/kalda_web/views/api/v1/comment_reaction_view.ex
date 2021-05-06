defmodule KaldaWeb.Api.V1.CommentReactionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{comment_reaction: comment_reaction}) do
    render_comment_reaction(comment_reaction)
  end

  def render_comment_reaction(comment_reaction) do
    %{
      relate: comment_reaction.relate,
      send_love: comment_reaction.send_love,
      author: UserView.render_author(comment_reaction.author),
      comment_id: comment_reaction.comment_id,
      inserted_at: comment_reaction.inserted_at
    }
  end
end
