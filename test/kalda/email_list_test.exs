defmodule Kalda.EmailListsTest do
  use Kalda.DataCase

  alias Kalda.EmailLists

  describe "waitlist_signups" do
    alias Kalda.EmailLists.WaitlistSignup

    @valid_email "some@email.com"
    @invalid_email ""

    def waitlist_signup_fixture(attrs \\ %{}) do
      {:ok, waitlist_signup} =
        attrs
        |> Enum.into(@valid_email)
        |> EmailLists.get_or_create_waitlist_signup()

      waitlist_signup
    end

    test "list_waitlist_signups/0 returns all waitlist_signups" do
      waitlist_signup = waitlist_signup_fixture()
      assert EmailLists.list_waitlist_signups() == [waitlist_signup]
    end

    test "get_or_create_waitlist_signup/1 with valid data creates a waitlist_signup" do
      assert {:ok, %WaitlistSignup{} = waitlist_signup} =
               EmailLists.get_or_create_waitlist_signup(@valid_email)

      assert waitlist_signup.email == "some@email.com"
    end

    test "get_or_create_waitlist_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               EmailLists.get_or_create_waitlist_signup(@invalid_email)
    end

    test "change_waitlist_signup/1 returns a waitlist_signup changeset" do
      waitlist_signup = waitlist_signup_fixture()
      assert %Ecto.Changeset{} = EmailLists.change_waitlist_signup(waitlist_signup)
    end

    test "can't duplicate emails" do
      email = "ASDF@example.com"
      {:ok, _} = EmailLists.get_or_create_waitlist_signup(email)
      {:ok, _} = EmailLists.get_or_create_waitlist_signup(email)
      assert length(EmailLists.list_waitlist_signups()) == 1
    end

    test "can't duplicate case insensitive emails" do
      email = "ASDF@example.com"
      {:ok, _} = EmailLists.get_or_create_waitlist_signup(email)
      {:ok, _} = EmailLists.get_or_create_waitlist_signup(String.downcase(email))
      assert length(EmailLists.list_waitlist_signups()) == 1
    end
  end

  # TODO implement dummy Sendfox for testing
  # describe "register with sendfox/1" do
  #   test "returns :ok if email included" do
  #     assert :ok = EmailLists.register_with_sendfox!("email@example.com")
  #   end
  # end
end
