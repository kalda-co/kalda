defmodule KaldaWeb.Api.V1.CommentReactionController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.CommentReaction

  def update(conn, %{"id" => comment_id} = comment_reaction_params) do
    user = conn.assigns.current_user
    comment = Forums.get_comment!(comment_id)

    with {:ok, %CommentReaction{} = comment_reaction} <-
           Forums.insert_or_update_comment_reaction(user.id, comment.id, comment_reaction_params) do
      comment_reaction = comment_reaction |> Map.put(:author, user)

      conn
      |> put_status(201)
      |> render("show.json", comment_reaction: comment_reaction)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
