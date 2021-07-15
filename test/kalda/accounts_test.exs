defmodule Kalda.AccountsTest do
  use Kalda.DataCase

  alias Kalda.Accounts
  alias Kalda.AccountsFixtures
  alias Kalda.Accounts.{User, UserToken, Invite, ReferralLink}

  @user_attrs %{
    username: "KaldaSquid",
    email: "demo@kalda.co",
    password: "thisisademopassword",
    mobile: "07444666666"
  }

  @second_user_attrs %{
    username: "KaldaSquid2",
    email: "demo2@kalda.co",
    password: "thisisademopassword",
    mobile: "07444666666"
  }

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = AccountsFixtures.user()
      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = AccountsFixtures.user()
      refute Accounts.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = AccountsFixtures.user()

      assert %User{id: ^id} =
               Accounts.get_user_by_email_and_password(
                 user.email,
                 AccountsFixtures.valid_user_password()
               )
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = AccountsFixtures.user()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email and password and username to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               username: ["can't be blank"],
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates username, email and password when given" do
      {:error, changeset} =
        Accounts.register_user(%{email: "not valid", password: "not valid", username: "not valid"})

      assert %{
               username: ["can only use letters, numbers, hyphens and underscores"],
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 130)
      {:error, changeset} = Accounts.register_user(%{email: too_long, password: too_long})
      assert "should be at most 254 character(s)" in errors_on(changeset).email
    end

    test "validates maximum value for username" do
      username = "A_valid_username_EXCEPT-that-it-Contains-too-many-CHARACTERS-the-max-is_35"
      {:error, changeset} = Accounts.register_user(%{username: username})
      assert "should be at most 35 character(s)" in errors_on(changeset).username
    end

    test "validates email uniqueness" do
      %{email: email} = AccountsFixtures.user()
      {:error, changeset} = Accounts.register_user(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates username uniqueness" do
      %{username: username} = AccountsFixtures.user()
      {:error, changeset} = Accounts.register_user(%{username: username})
      assert "has already been taken" in errors_on(changeset).username
    end

    test "registers users with a hashed password" do
      email = AccountsFixtures.unique_user_email()
      username = AccountsFixtures.unique_username()

      {:ok, user} =
        Accounts.register_user(%{
          username: username,
          email: email,
          password: AccountsFixtures.valid_user_password()
        })

      assert user.email == email
      assert user.username == username
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end

    test "registers all users with is_admin false" do
      email = AccountsFixtures.unique_user_email()
      username = AccountsFixtures.unique_username()

      {:ok, user} =
        Accounts.register_user(%{
          username: username,
          email: email,
          password: AccountsFixtures.valid_user_password()
        })

      assert user.email == email
      assert user.username == username
      assert user.is_admin == false
    end

    # TODO: When paywall is implemented this should test that all users register with has_free_subscription == false
    test "registers all users with has_free_subscription true" do
      email = AccountsFixtures.unique_user_email()
      username = AccountsFixtures.unique_username()

      {:ok, user} =
        Accounts.register_user(%{
          username: username,
          email: email,
          password: AccountsFixtures.valid_user_password()
        })

      assert user.email == email
      assert user.username == username
      assert user.is_admin == false
      assert user.has_free_subscription == true

      updated_user = Accounts.get_user_by_email(user.email)
      assert updated_user.has_free_subscription == true
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:username, :password, :email]
    end

    test "allows fields to be set" do
      email = AccountsFixtures.unique_user_email()
      password = AccountsFixtures.valid_user_password()
      username = AccountsFixtures.unique_username()

      changeset =
        Accounts.change_user_registration(%User{}, %{
          "email" => email,
          "password" => password,
          "username" => username
        })

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert get_change(changeset, :username) == username
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_user_email/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_email(%User{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_user_email/3" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, AccountsFixtures.valid_user_password(), %{})

      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, AccountsFixtures.valid_user_password(), %{
          email: "not valid"
        })

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 255)

      {:error, changeset} =
        Accounts.apply_user_email(user, AccountsFixtures.valid_user_password(), %{email: too_long})

      assert "should be at most 254 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{user: user} do
      %{email: email} = AccountsFixtures.user()

      {:error, changeset} =
        Accounts.apply_user_email(user, AccountsFixtures.valid_user_password(), %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, "invalid", %{email: AccountsFixtures.unique_user_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{user: user} do
      email = AccountsFixtures.unique_user_email()

      {:ok, user} =
        Accounts.apply_user_email(user, AccountsFixtures.valid_user_password(), %{email: email})

      assert user.email == email
      assert Accounts.get_user!(user.id).email != email
    end
  end

  describe "deliver_update_email_instructions/3" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "sends token through notification", %{user: user} do
      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(user, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "change:current@example.com"
    end
  end

  describe "update_user_email/2" do
    setup do
      user = AccountsFixtures.user()
      email = AccountsFixtures.unique_user_email()

      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{user: user, token: token, email: email}
    end

    test "updates the email with a valid token", %{user: user, token: token, email: email} do
      assert Accounts.update_user_email(user, token) == :ok
      changed_user = Repo.get!(User, user.id)
      assert changed_user.email != user.email
      assert changed_user.email == email
      assert changed_user.confirmed_at
      assert changed_user.confirmed_at != user.confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email with invalid token", %{user: user} do
      assert Accounts.update_user_email(user, "oops") == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email if user email changed", %{user: user, token: token} do
      assert Accounts.update_user_email(%{user | email: "current@example.com"}, token) == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.update_user_email(user, token) == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_user_password(%User{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, AccountsFixtures.valid_user_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    # test "validates maximum values for password for security", %{user: user} do
    #   too_long = String.duplicate("db", 130)

    #   {:error, changeset} =
    #     Accounts.update_user_password(user, AccountsFixtures.valid_user_password(), %{password: too_long})

    #   assert "should be at most 80 character(s)" in errors_on(changeset).password
    # end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, "invalid", %{
          password: AccountsFixtures.valid_user_password()
        })

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Accounts.update_user_password(user, AccountsFixtures.valid_user_password(), %{
          password: "new valid password"
        })

      assert is_nil(user.password)
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)

      {:ok, _} =
        Accounts.update_user_password(user, AccountsFixtures.valid_user_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: AccountsFixtures.user().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = AccountsFixtures.user()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = AccountsFixtures.user()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_confirmation_instructions/2" do
    setup do
      %{user: AccountsFixtures.unconfirmed_user()}
    end

    test "sends token through notification", %{user: user} do
      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "confirm"
    end
  end

  describe "confirm_user/2" do
    setup do
      user = AccountsFixtures.unconfirmed_user()

      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "confirms the email with a valid token", %{user: user, token: token} do
      assert {:ok, confirmed_user} = Accounts.confirm_user(token)
      assert confirmed_user.confirmed_at
      assert confirmed_user.confirmed_at != user.confirmed_at
      assert Repo.get!(User, user.id).confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm with invalid token", %{user: user} do
      assert Accounts.confirm_user("oops") == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.confirm_user(token) == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "sends token through notification", %{user: user} do
      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/1" do
    setup do
      user = AccountsFixtures.user()

      token =
        AccountsFixtures.extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "returns the user with valid token", %{user: %{id: id}, token: token} do
      assert %User{id: ^id} = Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: id)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Accounts.get_user_by_reset_password_token("oops")
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "reset_user_password/2" do
    setup do
      %{user: AccountsFixtures.user()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.reset_user_password(user, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    # test "validates maximum values for password for security", %{user: user} do
    #   too_long = String.duplicate("db", 130)
    #   {:error, changeset} = Accounts.reset_user_password(user, %{password: too_long})
    #   assert "should be at most 80 character(s)" in errors_on(changeset).password
    # end

    test "updates the password", %{user: user} do
      {:ok, updated_user} = Accounts.reset_user_password(user, %{password: "new valid password"})
      assert is_nil(updated_user.password)
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)
      {:ok, _} = Accounts.reset_user_password(user, %{password: "new valid password"})
      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "get_invite_for_token" do
    test "gets invite if token is valid" do
      email = "example@email.com"
      {token, _invite} = AccountsFixtures.invite(email)

      assert %Invite{} = invite = Accounts.get_invite_for_token(token)
      assert invite.invitee_email == email
    end

    test "fails if token invalid" do
      email = "email@example.com"
      {_token, invite_fixture} = AccountsFixtures.invite(email)

      assert invite_fixture.invitee_email == email

      refute Accounts.get_invite_for_token("gfhjsagfjlguy7658435785432")
    end
  end

  describe "create_user_from_invite" do
    test "creates invite if token and valid attrs" do
      username = AccountsFixtures.unique_username()
      password = AccountsFixtures.valid_user_password()
      attrs = %{username: username, password: password}
      email = "email@example.com"
      {token, _invite} = AccountsFixtures.invite(email)

      assert {:ok, %User{}} = Accounts.create_user_from_invite(token, attrs)
    end

    test "does not create invite if valid token but invalid username" do
      username = "!!!!NOPE!!!*&(^*&"
      password = AccountsFixtures.valid_user_password()
      attrs = %{username: username, password: password}
      email = "email@example.com"
      {token, _invite} = AccountsFixtures.invite(email)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_from_invite(token, attrs)
    end

    test "does not create invite if valid token but invalid password" do
      username = AccountsFixtures.unique_username()
      password = "password"
      attrs = %{username: username, password: password}
      email = "email@example.com"
      {token, _invite} = AccountsFixtures.invite(email)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_from_invite(token, attrs)
    end

    test "does not create invite if invalid token" do
      username = AccountsFixtures.unique_username()
      password = AccountsFixtures.valid_user_password()
      attrs = %{username: username, password: password}
      email = "ex@example.com"
      _invite = AccountsFixtures.invite(email)
      token = "72854722password"

      assert :not_found = Accounts.create_user_from_invite(token, attrs)
    end
  end

  describe "create_invite" do
    test "does not create invite if email is invalid" do
      email = "invalidemail"
      assert {:error, _changeset} = Accounts.create_invite(email)
    end
  end

  describe "create_referral" do
    test "create referral_link with valid attrs" do
      user = AccountsFixtures.user()
      name = "louis"
      referring_slots = 20
      expires_at = "2030-01-23T23:50:07"

      attrs = %{name: name, expires_at: expires_at, referring_slots: referring_slots}

      assert {:ok, referral_link} = Accounts.create_referral(user, attrs)

      assert referral_link.expires_at == NaiveDateTime.from_iso8601!(expires_at)
      assert referral_link.referring_slots == 20
    end

    test "does not create referral_link if name is not unique" do
      user = AccountsFixtures.user()
      user2 = AccountsFixtures.user()
      name = "louis"

      attrs = %{name: name, expires_at: NaiveDateTime.local_now()}

      assert {:ok, _referral} = Accounts.create_referral(user, attrs)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_referral(user2, attrs)
    end

    test "user can have many referral_links" do
      user = AccountsFixtures.user()
      name = "louis"
      name2 = "kalda"

      attrs = %{name: name, expires_at: NaiveDateTime.local_now()}
      attrs2 = %{name: name2, expires_at: NaiveDateTime.local_now()}

      assert {:ok, _referral} = Accounts.create_referral(user, attrs)
      assert {:ok, _referral} = Accounts.create_referral(user, attrs2)
    end

    test "does not create referral_link if name is not given" do
      user = AccountsFixtures.user()
      name = ""

      attrs = %{name: name, expires_at: NaiveDateTime.local_now()}

      assert {:error, %Ecto.Changeset{}} = Accounts.create_referral(user, attrs)
    end

    test "does not create referral_link if name is not valid" do
      user = AccountsFixtures.user()
      name = "under_score"

      attrs = %{name: name, expires_at: NaiveDateTime.local_now()}

      assert {:error, %Ecto.Changeset{}} = Accounts.create_referral(user, attrs)
    end

    test "does not create referral_link if name has capitals" do
      user = AccountsFixtures.user()
      name = "CAPital"

      attrs = %{name: name, expires_at: NaiveDateTime.local_now()}

      assert {:error, %Ecto.Changeset{}} = Accounts.create_referral(user, attrs)
    end
  end

  describe "create user from referral_link" do
    test "user created is NOT confirmed" do
      owner = AccountsFixtures.user()
      referral_link = AccountsFixtures.referral_link(owner)

      assert {:ok, %User{} = user} =
               Accounts.create_user_from_referral(referral_link.name, @user_attrs)

      assert user.confirmed_at == nil
      assert user.referred_by == referral_link.id
    end

    test "does not create user if name(referral_link) does not exist" do
      assert :not_found = Accounts.create_user_from_referral("name", @user_attrs)
    end

    test "does not create user if email or username already taken" do
      owner = AccountsFixtures.user()
      referral_link = AccountsFixtures.referral_link(owner)

      assert {:ok, %User{} = user} =
               Accounts.create_user_from_referral(referral_link.name, @user_attrs)

      assert user.confirmed_at == nil
      assert user.referred_by == referral_link.id

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.create_user_from_referral(referral_link.name, @user_attrs)

      assert "has already been taken" in errors_on(changeset).email
      assert "has already been taken" in errors_on(changeset).username
    end

    test "creating user from referral_link decrements the referring_slots on the referral_link" do
      owner = AccountsFixtures.user()
      referral_link = AccountsFixtures.referral_link(owner, %{referring_slots: 1})
      assert referral_link.referring_slots == 1

      assert {:ok, %User{} = user} =
               Accounts.create_user_from_referral(referral_link.name, @user_attrs)

      assert user.confirmed_at == nil
      assert user.referred_by == referral_link.id

      assert :not_found =
               Accounts.create_user_from_referral(referral_link.name, @second_user_attrs)

      assert updated_referral = Accounts.get_referral!(referral_link.id)

      assert updated_referral.referring_slots == 0
    end

    test "you can get the email/user_id of the user who referred the user created from this referral_link" do
      owner = AccountsFixtures.user(%{email: "ref@email.com"})
      referral_link = AccountsFixtures.referral_link(owner, %{referring_slots: 1})
      assert referral_link.referring_slots == 1

      assert {:ok, %User{} = user} =
               Accounts.create_user_from_referral(referral_link.name, @user_attrs)

      assert user.confirmed_at == nil
      assert user.referred_by == referral_link.id

      ref = Accounts.get_referral!(user.referred_by)
      ref_user = Accounts.get_user!(ref.owner_id)
      assert ref_user.email == "ref@email.com"
    end
  end

  describe "get_referral_link_by_name" do
    test "only gets referral_links that have not expired" do
      owner = AccountsFixtures.user()

      assert %ReferralLink{} = AccountsFixtures.referral_link(owner, %{name: "name"})

      assert referral_link = %ReferralLink{} = Accounts.get_referral_link_by_name("name")
      assert referral_link.name == "name"

      assert {1, nil} =
               Kalda.Repo.update_all(Kalda.Accounts.ReferralLink,
                 set: [expires_at: ~N[2020-01-01 00:00:00]]
               )

      refute Accounts.get_referral_link_by_name("name")
    end

    test "only gets referral_links with referring_slots" do
      owner = AccountsFixtures.user()
      _referral = AccountsFixtures.referral_link(owner, %{name: "name", referring_slots: 0})

      refute Accounts.get_referral_link_by_name("name")
    end
  end

  # TODO add guidelines to signup flow
end
