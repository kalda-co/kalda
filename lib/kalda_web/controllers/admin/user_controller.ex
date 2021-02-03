defmodule KaldaWeb.Admin.UserController do
  use KaldaWeb, :controller
  alias Kalda.Accounts
  alias Kalda.Policy

  def user_index(conn, _params) do
    user = conn.assigns.current_user
    Policy.authorize!(user, :view_admin_pages, Kalda)
    # TODO add pagination, do not get all users
    users = Accounts.get_users()
    render(conn, "user_index.html", users: users, error_message: "not authorised")
  end
end
