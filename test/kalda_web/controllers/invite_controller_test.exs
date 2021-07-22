defmodule KaldaWeb.InviteControllerTest do
  use KaldaWeb.ConnCase

  alias Kalda.Accounts
  alias Kalda.Accounts.User

  @create_user_attrs %{username: "myusername", password: "vaildpassword12345678"}
  @invalid_user_attrs %{username: "myusername", password: "invalid"}

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

    # TODO: Should the show page also query the db to see if the invitee email has already got an account?

    test "if token has been used, and user exists, they are not logged in just from the link, in case someone else got the invite link",
         %{conn: conn} do
      {token, _invite} = Kalda.AccountsFixtures.invite("a@example.com")
      conn = get(conn, Routes.invite_path(conn, :show, token))

      assert html_response(conn, 200) =~ "Welcome to Kalda"
      refute conn.assigns.current_user
      conn = get(conn, Routes.invite_path(conn, :show, token))

      assert html_response(conn, 200) =~ "Welcome to Kalda"
      refute conn.assigns.current_user
    end
  end

  describe "POST invites" do
    test "post invites creates a user for invitee_email", %{conn: conn} do
      {token, invite} = Kalda.AccountsFixtures.invite()

      conn =
        post(conn, Routes.invite_path(conn, :create),
          user: Map.put(@create_user_attrs, :token, token)
        )

      # test the user has been created
      assert %User{} = user = Accounts.get_user_by_email(invite.invitee_email)
      assert user.email == invite.invitee_email

      assert get_flash(conn, :info) == "Account created successfully"
      assert redirected_to(conn, 302) =~ "/dashboard"

      assert user.has_free_subscription == true
    end

    test "invalid attrs", %{conn: conn} do
      {token, invite} = Kalda.AccountsFixtures.invite()

      post(conn, Routes.invite_path(conn, :create),
        user: Map.put(@invalid_user_attrs, :token, token)
      )

      refute Accounts.get_user_by_email(invite.invitee_email)
    end

    # TODO: decide if we really want this feature
    test "Username already exists", %{conn: conn} do
      _user = Kalda.AccountsFixtures.user(%{username: "myusername"})
      {token, invite} = Kalda.AccountsFixtures.invite()

      post(conn, Routes.invite_path(conn, :create),
        user: Map.put(@create_user_attrs, :token, token)
      )

      refute Accounts.get_user_by_email(invite.invitee_email)
      # TODO: If keeping this feature ensure changeset returned to user
    end

    test "invite already used, logged in user redirected", %{conn: conn} do
      {token, invite} = Kalda.AccountsFixtures.invite()

      conn =
        post(conn, Routes.invite_path(conn, :create),
          user: Map.put(@create_user_attrs, :token, token)
        )

      # The user has been created from the token
      assert %User{} = user = Accounts.get_user_by_email(invite.invitee_email)
      assert user.email == invite.invitee_email

      # Same token url tried, user still logged in
      conn = get(conn, Routes.invite_path(conn, :show, token))

      # User stays logged in, just redirected to app
      assert redirected_to(conn, 302) =~ "/dashboard"
      assert user == conn.assigns.current_user
    end

    test "invite already used, on submitting params user sees 'token expired'", %{conn: conn} do
      {token, invite} = Kalda.AccountsFixtures.invite()

      conn =
        post(conn, Routes.invite_path(conn, :create),
          user: Map.put(@create_user_attrs, :token, token)
        )

      # The user has been created from the token
      assert %User{} = user = Accounts.get_user_by_email(invite.invitee_email)
      assert user.email == invite.invitee_email

      # Log out user
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      # Same token url tried, user has logged out
      conn = get(conn, Routes.invite_path(conn, :show, token))

      # User sees 'token expired' html
      assert html_response(conn, 200) =~ "expired"
      refute user == conn.assigns.current_user
    end
  end
end
