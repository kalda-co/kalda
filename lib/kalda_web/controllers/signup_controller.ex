defmodule KaldaWeb.WaitlistSignupController do
  use KaldaWeb, :controller

  alias Kalda.EmailLists

  def create(conn, %{"waitlist_signup" => %{"email" => email}}) do
    case EmailLists.get_or_create_waitlist_signup(email) do
      {:ok, waitlist_signup} ->
        EmailLists.register_with_sendfox!(waitlist_signup.email)

        conn
        |> put_flash(:info, "WaitlistSignup created successfully.")
        |> redirect(to: "/thanks")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> put_root_layout({KaldaWeb.LayoutView, :site_page})
        |> put_view(KaldaWeb.PageView)
        |> render("index.html", waitlist_signup_changeset: changeset)
    end
  end
end
