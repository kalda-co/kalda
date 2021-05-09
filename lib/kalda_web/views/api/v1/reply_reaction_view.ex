defmodule KaldaWeb.Api.V1.ReplyReactionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{reply_reaction: reply_reaction}) do
    render_reply_reaction(reply_reaction)
  end

  def render_reply_reaction(reply_reaction) do
    %{
      relate: reply_reaction.relate,
      send_love: reply_reaction.send_love,
      author: UserView.render_author(reply_reaction.author)
    }
  end
end
