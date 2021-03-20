defmodule KaldaWeb.Admin.UserController do
  use KaldaWeb, :controller
  alias Kalda.Accounts
  alias Kalda.Policy

  def index(conn, _params) do
    # The authorize! function knows how to get the user off the conn
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    users = Accounts.get_users(preload: [referral_link: [:owner]])
    render(conn, "index.html", users: users, error_message: "not authorised")
  end
end
