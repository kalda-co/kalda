defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  @doc """
  This 'show' shows the single post to the user when they click on a notification, and reoders the comments so that their comment is first
  """

  def show(conn, %{"post_id" => post_id, "comment_id" => comment_id}) do
    post = Forums.get_post_order_preloads!(post_id)
    comments = post.comments

    {comment_id_int, _} = Integer.parse(comment_id)

    original_comment =
      Enum.filter(comments, fn
        comment ->
          comment.id == comment_id_int
      end)

    other_comments =
      Enum.filter(comments, fn
        comment -> comment.id != comment_id_int
      end)

    ordered_comments = List.flatten(original_comment ++ other_comments)

    # IO.inspect(ordered_comments, label: "[ordered comments]")

    conn
    |> put_status(200)
    |> render("show.json", post: post, ordered_comments: ordered_comments)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
