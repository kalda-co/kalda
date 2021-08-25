defmodule KaldaWeb.UserRegistrationControllerTest do
  use KaldaWeb.ConnCase, async: true

  alias Kalda.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Create an account</h1>"
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
    test "creates account and prompts user to check email", %{conn: conn} do
      email = AccountsFixtures.unique_user_email()
      username = AccountsFixtures.unique_username()
      mobile = "07277 123 456"

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "username" => username,
            "password" => AccountsFixtures.valid_user_password(),
            "mobile" => mobile
          }
        })

      assert get_flash(conn, :info) ==
               "Success. Please check your emails and click the link to confirm your account."

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "App</a>"
      # Assert user created
      user = Kalda.Accounts.get_user_by_email(email)
      assert user.mobile == mobile
      assert user.has_stripe_subscription == false
      assert user.has_free_subscription == false
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
