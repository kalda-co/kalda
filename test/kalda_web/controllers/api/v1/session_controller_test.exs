defmodule KaldaWeb.Api.V1.SessionControllerTest do
  use KaldaWeb.ConnCase

  @invalid_user_input %{
    email: "a1",
    password: "a1"
  }

  @valid_user_input %{
    email: "email@kalda.co",
    password: "thisisatestpassword"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST create" do
    test "renders 422 with errors for invalid attributes", %{conn: conn} do
      assert conn = post(conn, "/v1/users/session", @invalid_user_input)

      assert json_response(conn, 422)
    end

    test "valid attributes", %{conn: conn} do
      user = Kalda.AccountsFixtures.user(@valid_user_input)
      assert conn = post(conn, "/v1/users/session", @valid_user_input)
      assert %{"token" => token} = json_response(conn, 201)
      assert user2 = Kalda.Accounts.get_user_by_api_auth_token(token)
      assert user.id == user2.id
    end
  end
end
