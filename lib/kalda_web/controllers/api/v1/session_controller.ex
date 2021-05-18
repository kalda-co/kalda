defmodule KaldaWeb.Api.V1.SessionController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  # alias KaldaWeb.UserAuth

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        KaldaWeb.Api.V1.handle_error({:error, :not_found}, conn)

      user ->
        user_token = Accounts.generate_user_session_token(user)

        conn
        |> configure_session(renew: true)
        |> clear_session()
        |> put_status(201)
        |> put_session(:user_token, user_token)
        |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(user_token)}")
        |> render("show.json", user: user)
    end
  end
end
