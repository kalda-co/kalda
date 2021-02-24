defmodule KaldaWeb.UserRegistrationControllerTest do
  use KaldaWeb.ConnCase, async: true

  alias Kalda.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Create an account</h1>"
      assert response =~ "Log in</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn
        |> log_in_user(AccountsFixtures.user())
        |> get(Routes.user_registration_path(conn, :new))

      assert redirected_to(conn) == "/app"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = AccountsFixtures.unique_user_email()
      username = AccountsFixtures.unique_username()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "username" => username,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      # assert response =~ "user email"
      # assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "password" => "too short",
            "username" => "I am the Puppy Queen but I am also the Kraken of justice!!!"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Create an account</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
      assert response =~ "should be at most 35 character"
      assert response =~ "can only use letters, numbers, hyphens and underscores"
    end
  end
end
