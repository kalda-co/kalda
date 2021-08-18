defmodule KaldaWeb.SignupController do
  use KaldaWeb, :controller

  alias Kalda.EmailLists

  def create(conn, %{"signup" => %{"email" => email}}) do
    list_id = Application.get_env(:kalda, :sendfox_waitlist_id)

    case EmailLists.get_or_create_signup(email) do
      {:ok, signup} ->
        EmailLists.register_with_sendfox!(signup.email, list_id)

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
