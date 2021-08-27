defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def show(conn, %{"id" => id}) do
    post = Forums.get_post_order_preloads!(id)
    comments = post.comments

    comment_id = "abc"

    original_comment =
      Enum.filter(comments, fn
        comment -> comment.id == comment_id
      end)

    other_comments =
      Enum.filter(comments, fn
        comment -> comment.id != comment_id
      end)

    ordered_comments = List.flatten([original_comment, other_comments])

    IO.inspect(original_comment)

    conn
    |> put_status(200)
    |> render("show.json", post: post, ordered_comments: ordered_comments)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
