defmodule KaldaWeb.Api.V1.CommentController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def create(conn, %{"id" => post_id, "comment" => comment_params}) do
    user = conn.assigns.current_user
    post = Forums.get_post!(post_id, preload: [:author, comments: [:author, replies: [:author]]])

    case Forums.create_comment(user, post, comment_params) do
      {:ok, _comment} ->
        conn
        |> redirect(to: "v1/daily-reflections")

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("new.json", changeset: changeset)
    end
  end
end
