defmodule KaldaWeb.Api.V1.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  @doc """
  This 'show' shows the single post to the user when they click on a notification
  """

  def show(conn, %{"id" => id}) do
    post = Forums.get_post_order_preloads!(id)

    conn
    |> put_status(200)
    |> render("show.json", post: post)
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
