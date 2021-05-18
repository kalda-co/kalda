defmodule KaldaWeb.Api.V1.SessionController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  # alias KaldaWeb.UserAuth

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> KaldaWeb.Api.V1.handle_error({:error, :not_found})

      user ->
        user_token = Accounts.generate_user_session_token(user)

        conn
        |> put_status(201)
        |> render("show.json", user: user, user_token: user_token)
    end
  end
end
