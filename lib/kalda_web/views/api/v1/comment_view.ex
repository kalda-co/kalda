defmodule KaldaWeb.Api.V1.CommentView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.ReplyView
  alias KaldaWeb.Api.V1.CommentReactionView

  def render("show_subscribed_author.json", %{comment: comment}) do
    render_comment_subscribed_author(comment)
  end

  def render("show.json", %{comment: comment}) do
    render_comment(comment)
  end

  def render_comment_subscribed_author(comment) do
    %{
      id: comment.id,
      content: comment.content,
      inserted_at: comment.inserted_at,
      author: UserView.render_author_with_subscription(comment.author),
      replies: Enum.map(comment.replies, &ReplyView.render_reply/1),
      reactions:
        Enum.map(comment.comment_reactions, &CommentReactionView.render_comment_reaction/1)
    }
  end

  def render_comment(comment) do
    %{
      id: comment.id,
      content: comment.content,
      inserted_at: comment.inserted_at,
      author: UserView.render_author(comment.author),
      replies: Enum.map(comment.replies, &ReplyView.render_reply/1),
      reactions:
        Enum.map(comment.comment_reactions, &CommentReactionView.render_comment_reaction/1)
    }
  end
end
