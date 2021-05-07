defmodule KaldaWeb.UserSessionController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  alias KaldaWeb.UserAuth
  alias Kalda.Waitlist
  alias Kalda.Waitlist.Signup

  def new(conn, _params) do
    signup_changeset = Waitlist.change_signup(%Signup{})
    render(conn, "new.html", signup_changeset: signup_changeset, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    signup_changeset = Waitlist.change_signup(%Signup{})
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html",
        error_message: "Invalid email or password",
        signup_changeset: signup_changeset
      )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
