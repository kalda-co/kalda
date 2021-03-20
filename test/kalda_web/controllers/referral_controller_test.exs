defmodule KaldaWeb.ReferralLinkControllerTest do
  use KaldaWeb.ConnCase

  alias Kalda.Accounts
  alias Kalda.Accounts.User

  @create_user_attrs %{
    username: "myusername",
    password: "vaildpassword12345678",
    email: "referred@example.com"
  }
  @second_user_attrs %{
    username: "myusername2",
    password: "vaildpassword12345678",
    email: "referred2@example.com"
  }
  @invalid_user_attrs %{
    username: "myusername",
    password: "invalid",
    email: "referred@example.com"
  }

  describe "GET referral_links/:name" do
    test "if name matches a referral_link it is returned", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.referral_link(referring_user)

      conn = get(conn, Routes.referral_link_path(conn, :show, referral_link.name))

      assert html_response(conn, 200) =~ "Create an account"
    end

    test "if name has expired, the exprired view is rendered", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.expired_referral(referring_user)

      conn = get(conn, Routes.referral_link_path(conn, :show, referral_link.name))

      assert html_response(conn, 200) =~ "your token may have expired"
    end
  end

  describe "POST referral_links" do
    test "post referral_links creates a user for user params and link name", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.referral_link(referring_user)

      conn =
        post(conn, Routes.referral_link_path(conn, :create),
          user: Map.put(@create_user_attrs, :name, referral_link.name)
        )

      # test the user has been created
      assert %User{} = user = Accounts.get_user_by_email("referred@example.com")
      assert user.referred_by == referral_link.id

      assert get_flash(conn, :info) ==
               "User created successfully. Please check your email for confirmation instructions"

      assert redirected_to(conn, 302) == "/users/confirm"
    end

    test "invalid attrs", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.referral_link(referring_user)

      post(conn, Routes.referral_link_path(conn, :create),
        user: Map.put(@invalid_user_attrs, :name, referral_link.name)
      )

      refute Accounts.get_user_by_email("referred@example.com")
    end

    test "Username already exists", %{conn: conn} do
      _user = Kalda.AccountsFixtures.user(%{username: "myusername"})

      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.referral_link(referring_user)

      post(conn, Routes.referral_link_path(conn, :create),
        user: Map.put(@create_user_attrs, :name, referral_link.name)
      )

      refute Accounts.get_user_by_email("referred@example.com")
    end

    test "referral_link has no slots, user is shown expired", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.referral_link(referring_user, %{referring_slots: 1})

      # This will use up the last referral_link slot
      post(conn, Routes.referral_link_path(conn, :create),
        user: Map.put(@create_user_attrs, :name, referral_link.name)
      )

      assert Accounts.get_user_by_email("referred@example.com")

      # This will fail because there are no more slots
      post(conn, Routes.referral_link_path(conn, :create),
        user: Map.put(@second_user_attrs, :name, referral_link.name)
      )

      refute Accounts.get_user_by_email("referred2@example.com")
    end

    test "referral_link expired, user sees expired", %{conn: conn} do
      referring_user = Kalda.AccountsFixtures.user(%{email: "test@example.com"})
      referral_link = Kalda.AccountsFixtures.expired_referral(referring_user)

      conn =
        post(conn, Routes.referral_link_path(conn, :create),
          user: Map.put(@create_user_attrs, :name, referral_link.name)
        )

      assert html_response(conn, 200) =~ "your token may have expired"
    end
  end
end
