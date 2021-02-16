defmodule KaldaWeb.Admin.FlagControllerTest do
  use KaldaWeb.ConnCase

  describe "flag_index" do
    setup [:register_and_log_in_user]

    test "redirects if not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_flag_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "flag_index as admin" do
    setup [:register_and_log_in_admin]

    test "lists all flags if admin", %{conn: conn} do
      conn = get(conn, Routes.admin_flag_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Flags"
    end
  end
end
