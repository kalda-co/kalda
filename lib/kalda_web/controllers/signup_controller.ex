defmodule KaldaWeb.SignupController do
  use KaldaWeb, :controller

  alias Kalda.Waitlist

  def create(conn, %{"signup" => %{"email" => email}}) do
    case Waitlist.get_or_create_signup(email) do
      {:ok, signup} ->
        Waitlist.register_with_sendfox!(signup.email)

        conn
        |> put_flash(:info, "Signup created successfully.")
        |> redirect(to: "/thanks")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> put_root_layout({KaldaWeb.LayoutView, :site_page})
        |> put_view(KaldaWeb.PageView)
        |> render("index.html", signup_changeset: changeset)
    end
  end
end
