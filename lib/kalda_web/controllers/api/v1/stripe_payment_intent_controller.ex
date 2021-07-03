defmodule KaldaWeb.Api.V1.StripePaymentIntentController do
  use KaldaWeb, :controller

  alias Kalda.Payments

  def create(conn, _params) do
    # user = conn.assigns.current_user
    # post = Forums.get_post!(post_id)

    # with {:ok, %Comment{} = comment} <- Forums.create_comment(user, post, comment_params) do
    #   comment =
    #     comment
    #     |> Map.put(:author, user)
    #     |> Map.put(:replies, [])
    #     |> Map.put(:comment_reactions, [])

    #   conn
    #   |> put_status(201)
    #   |> render("show.json", comment: comment)
    # end
    # |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
