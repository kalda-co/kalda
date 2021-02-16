defmodule KaldaWeb.Api.V1.FlagController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Forums.Flag

  def create_flag_comment(conn, %{"id" => comment_id} = flag_params) do
    user = conn.assigns.current_user
    comment = Forums.get_comment!(comment_id)

    with {:ok, %Flag{} = flag} <- Forums.create_flag_comment(user, comment, flag_params) do
      flag = flag |> Map.put(:reporter, user)

      conn
      |> put_status(201)
      |> render("show.json", flag: flag)
    end
    |> KaldaWeb.Api.V1.handle_error(conn)
  end
end
