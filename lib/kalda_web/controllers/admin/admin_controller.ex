defmodule KaldaWeb.Admin.AdminController do
  use KaldaWeb, :controller

  def index(conn, _params) do
    Policy.authorize!(conn, :view_admin, Kalda)
  end
end
