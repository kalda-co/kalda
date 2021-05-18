defmodule KaldaWeb.Api.V1.SessionController do
  use KaldaWeb, :controller

  alias Kalda.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_status(422)
        |> render("invalid.json")

      user ->
        conn
        |> put_status(201)
        |> render("show.json", token: Accounts.generate_api_auth_token(user))
    end
  end
end
