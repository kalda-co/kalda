defmodule KaldaWeb.Admin.ReferralControllerTest do
  use KaldaWeb.ConnCase

  @create_referral_attrs %{
    email: "test@example.com",
    name: "link-get-kalda",
    referring_slots: 6,
    expires_at: "2030-01-23T23:50:07"
  }
  @create_referral_attrs_with_defaults %{
    email: "test@example.com",
    name: "link-get-kalda"
  }
  @invalid_referral_attrs %{
    name: "",
    email: "test@example.com"
  }

  describe "new referral" do
    setup [:register_and_log_in_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_referral_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "new referral as admin" do
    setup [:register_and_log_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_referral_path(conn, :new))
      assert html_response(conn, 200) =~ "New Referral"
    end
  end

  describe "create referral" do
    setup [:register_and_log_in_user]

    test "redirects when user is not admin", %{conn: conn} do
      conn =
        post(conn, Routes.admin_referral_path(conn, :create), referral: @create_referral_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :error) == "You are not authorised to access this page."
    end
  end

  describe "create referral as admin" do
    setup [:register_and_log_in_admin]

    test "redirects to show when data is valid and user is admin", %{conn: conn} do
      _user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})

      conn =
        post(conn, Routes.admin_referral_path(conn, :create), referral: @create_referral_attrs)

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :info) =~ "Referral created"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      _user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})

      conn =
        post(conn, Routes.admin_referral_path(conn, :create), referral: @invalid_referral_attrs)

      assert html_response(conn, 422) =~ "Please check the errors below"
    end

    test "renders error flash when referrer user doesn't exist", %{conn: conn} do
      conn =
        post(conn, Routes.admin_referral_path(conn, :create), referral: @create_referral_attrs)

      assert get_flash(conn, :error) =~ "No user exists that matches this email"
    end

    test "redirects to show when data uses defaults and user is admin", %{conn: conn} do
      _user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})

      conn =
        post(conn, Routes.admin_referral_path(conn, :create),
          referral: @create_referral_attrs_with_defaults
        )

      assert html_response(conn, 302) =~ "redirected"
      assert get_flash(conn, :info) =~ "Referral created"
    end
  end
end
