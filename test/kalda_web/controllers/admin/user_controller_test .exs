defmodule KaldaWeb.Admin.UserControllerTest do
  use KaldaWeb.ConnCase

  describe "user_index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.user_post_path(conn, :user_index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "user_index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all users if admin", %{conn: conn} do
      conn = get(conn, Routes.user_post_path(conn, :user_index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end
end
