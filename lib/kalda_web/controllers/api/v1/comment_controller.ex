defmodule KaldaWeb.Api.V1.CommentController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Forums.Comment

  def create(conn, %{"id" => post_id} = comment_params) do
    user = conn.assigns.current_user
    post = Forums.get_post!(post_id)

    with {:ok, %Comment{} = comment} <- Forums.create_comment(user, post, comment_params) do
      comment = comment |> Map.put(:author, user) |> Map.put(:replies, [])

      conn
      |> put_status(201)
      |> render("show.json", comment: comment)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end

  def show(conn, %{"id" => id}) do
    comment = Forums.get_comment!(id, preload: [:author, replies: [:author]])
    # render(conn, "show.json", comment: comment, author: comment.author)
    render(conn, "show.json", comment: comment)
  end
end
