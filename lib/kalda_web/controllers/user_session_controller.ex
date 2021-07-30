defmodule KaldaWeb.UserSessionController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  alias KaldaWeb.UserAuth
  alias Kalda.EmailLists
  alias Kalda.EmailLists.WaitlistSignup

  def new(conn, _params) do
    waitlist_signup_changeset = EmailLists.change_waitlist_signup(%WaitlistSignup{})

    render(conn, "new.html",
      waitlist_signup_changeset: waitlist_signup_changeset,
      error_message: nil
    )
  end

  def create(conn, %{"user" => user_params}) do
    waitlist_signup_changeset = EmailLists.change_waitlist_signup(%WaitlistSignup{})
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html",
        error_message: "Invalid email or password",
        waitlist_signup_changeset: waitlist_signup_changeset
      )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
