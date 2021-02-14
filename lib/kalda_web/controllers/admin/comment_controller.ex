defmodule KaldaWeb.Admin.CommentController do
  use KaldaWeb, :controller

  alias Kalda.Forums
  alias Kalda.Policy

  def delete(conn, %{"id" => id}) do
    Policy.authorize!(conn, :delete_admin_comment, Kalda)
    comment = Forums.get_comment!(id)
    {:ok, _comment} = Forums.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index))
  end
end
