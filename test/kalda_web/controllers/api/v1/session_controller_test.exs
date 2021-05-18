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
      assert conn = post(conn, "/v1/users/log-in", @invalid_user_input)

      assert json_response(conn, 422) == %{
               "errors" => %{
                 "email" => ["must have the @ sign and no spaces"],
                 "password" => ["must have at least 12 characters"]
               }
             }
    end

    test "valid attributes", %{conn: conn} do
      user = Kalda.AccountsFixtures.user(@valid_user_input)
      assert conn = post(conn, "/v1/users/log-in", @valid_user_input)

      user_token = "no idea, tis seems insecure anyway"
      csrf_token = Plug.CSRFProtection.get_csrf_token()

      assert json_response(conn, 201) == %{
               "user" => %{
                 "id" => user.id,
                 "username" => user.username
               },
               "user_token" => user_token,
               "csrf_token" => csrf_token
             }
    end
  end
end
