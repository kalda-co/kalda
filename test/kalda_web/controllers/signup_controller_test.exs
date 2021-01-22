defmodule KaldaWeb.SignupControllerTest do
  use KaldaWeb.ConnCase

  alias Kalda.Waitlist

  @create_attrs %{email: "some email"}
  # @update_attrs %{email: "some updated email"}
  @invalid_attrs %{email: nil}

  def fixture(:signup) do
    {:ok, signup} = Waitlist.create_signup(@create_attrs)
    signup
  end

  # TODO when admin implemented
  # describe "index" do
  #   setup :register_and_log_in_admin

  #   test "lists all signups", %{conn: conn} do
  #     conn = get(conn, Routes.signup_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing Signups"
  #   end
  # end

  describe "create signup" do
    # TODO flash for success
    test "redirects to /thanks when data is valid", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :create), signup: @create_attrs)

      conn = get(conn, Routes.signup_path(conn, :index))
      assert html_response(conn, 200) =~ "Signup"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :create), signup: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Signup"
    end
  end
end
