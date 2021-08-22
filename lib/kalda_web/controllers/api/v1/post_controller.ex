defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def show(conn, %{"id" => id}) do
    post =
      Forums.get_post!(id,
        preload: [
          :author,
          comments: [
            :author,
            comment_reactions: [
              :author
            ],
            replies: [
              :author,
              reply_reactions: [
                :author
              ]
            ]
          ]
        ]
      )

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
