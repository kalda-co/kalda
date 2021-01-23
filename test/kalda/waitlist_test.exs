defmodule Kalda.WaitlistTest do
  use Kalda.DataCase

  alias Kalda.Waitlist

  describe "signups" do
    alias Kalda.Waitlist.Signup

    @valid_attrs %{email: "some@email.com"}
    @invalid_attrs %{email: nil}

    def signup_fixture(attrs \\ %{}) do
      {:ok, signup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Waitlist.create_signup()

      signup
    end

    test "list_signups/0 returns all signups" do
      signup = signup_fixture()
      assert Waitlist.list_signups() == [signup]
    end

    test "create_signup/1 with valid data creates a signup" do
      assert {:ok, %Signup{} = signup} = Waitlist.create_signup(@valid_attrs)
      assert signup.email == "some@email.com"
    end

    test "create_signup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Waitlist.create_signup(@invalid_attrs)
    end

    test "change_signup/1 returns a signup changeset" do
      signup = signup_fixture()
      assert %Ecto.Changeset{} = Waitlist.change_signup(signup)
    end

    test "can't duplicate case insensitive emails" do
      email = "ASDF@example.com"
      _signup = Waitlist.create_signup(%{email: email})

      assert {:error, %Ecto.Changeset{errors: [email: {"has already been taken", _}]}} =
               Waitlist.create_signup(%{email: String.downcase(email)})
    end
  end
end
