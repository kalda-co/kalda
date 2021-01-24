defmodule Kalda.WaitlistTest do
  use Kalda.DataCase

  alias Kalda.Waitlist

  describe "signups" do
    alias Kalda.Waitlist.Signup

    @valid_email "some@email.com"
    @invalid_email ""

    def signup_fixture(attrs \\ %{}) do
      {:ok, signup} =
        attrs
        |> Enum.into(@valid_email)
        |> Waitlist.get_or_create_signup()

      signup
    end

    test "list_signups/0 returns all signups" do
      signup = signup_fixture()
      assert Waitlist.list_signups() == [signup]
    end

    test "get_or_create_signup/1 with valid data creates a signup" do
      assert {:ok, %Signup{} = signup} = Waitlist.get_or_create_signup(@valid_email)
      assert signup.email == "some@email.com"
    end

    test "get_or_create_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Waitlist.get_or_create_signup(@invalid_email)
    end

    test "change_signup/1 returns a signup changeset" do
      signup = signup_fixture()
      assert %Ecto.Changeset{} = Waitlist.change_signup(signup)
    end

    test "can't duplicate emails" do
      email = "ASDF@example.com"
      {:ok, _} = Waitlist.get_or_create_signup(email)
      {:ok, _} = Waitlist.get_or_create_signup(email)
      assert length(Waitlist.list_signups()) == 1
    end

    test "can't duplicate case insensitive emails" do
      email = "ASDF@example.com"
      {:ok, _} = Waitlist.get_or_create_signup(email)
      {:ok, _} = Waitlist.get_or_create_signup(String.downcase(email))
      assert length(Waitlist.list_signups()) == 1
    end
  end
end
