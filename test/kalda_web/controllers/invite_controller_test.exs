defmodule KaldaWeb.InviteControllerTest do
  use KaldaWeb.ConnCase

  @create_user_attrs %{username: "myusername", password: "vaildpassword12345678"}

  describe "GET invites/:token" do
    test "if token matches an invite it is returned", %{conn: conn} do
      {token, _invite} = Kalda.AccountsFixtures.invite("a@example.com")
      conn = get(conn, Routes.invite_path(conn, :show, token))

      assert html_response(conn, 200) =~ "Welcome to Kalda"
    end

    test "if token has expired, the exprired view is rendered", %{conn: conn} do
      {token, _invite} = Kalda.AccountsFixtures.expired_invite()
      conn = get(conn, Routes.invite_path(conn, :show, token))

      assert html_response(conn, 200) =~ "your token may have expired"
    end

    test "invite already used"
  end

  describe "POST invites" do
    test "post invites creates a user for invitee_email", %{conn: conn} do
      {token, _invite} = Kalda.AccountsFixtures.invite()

      conn =
        post(conn, Routes.invite_path(conn, :create),
          user: Map.put(@create_user_attrs, :token, token)
        )

      # TODO: test the user has been created

      assert get_flash(conn, :info) == "Account created successfully"
      assert redirected_to(conn, 302) =~ "/"
    end

    test "invalid attrs"

    test "invite already used"
  end
end
