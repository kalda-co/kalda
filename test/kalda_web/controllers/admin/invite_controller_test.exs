defmodule KaldaWeb.Admin.InviteControllerTest do
  use KaldaWeb.ConnCase

  @create_invite_attrs %{email: "hi@example.com"}
  @invalid_invite_attrs %{email: "hiexamplecom"}

  describe "new invite" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_invite_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new invite as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_invite_path(conn, :new))
      assert html_response(conn, 200) =~ "New Invite"
    end
  end

  describe "create invite" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn = post(conn, Routes.admin_invite_path(conn, :create), invite: @create_invite_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create invite as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to show when data is valid and user is admin", %{conn: conn} do
      conn = post(conn, Routes.admin_invite_path(conn, :create), invite: @create_invite_attrs)

      assert html_response(conn, 200) =~ "New Invite"
      assert get_flash(conn, :info) == "Invite created and email sent"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_invite_path(conn, :create), invite: @invalid_invite_attrs)
      response = html_response(conn, 403)
      assert response =~ "Please check the errors below"
    end
  end
end
