defmodule KaldaWeb.Admin.FlagController do
  use KaldaWeb, :controller
  alias Kalda.Forums
  alias Kalda.Policy

  def index(conn, _params) do
    # The authorize! function knows how to get the user off the conn
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    flags = Forums.get_unresolved_flags()
    render(conn, "index.html", flags: flags, error_message: "not authorised")
  end
end
