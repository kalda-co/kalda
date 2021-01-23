defmodule KaldaWeb.SignupController do
  use KaldaWeb, :controller

  alias Kalda.Waitlist

  # def index(conn, _params) do
  #   signups = Waitlist.list_signups()
  #   render(conn, "index.html", signups: signups)
  # end

  # def all(conn, _params) do
  #   signups = Waitlist.list_signups()
  #   render(conn, "all.html", signups: signups)
  # end

  def create(conn, %{"signup" => signup_params}) do
    case Waitlist.create_signup(signup_params) do
      {:ok, signup} ->
        Waitlist.sendfox_post_request!(signup.email)

        conn
        |> put_flash(:info, "Signup created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> put_root_layout({KaldaWeb.LayoutView, :site_page})
        |> put_view(KaldaWeb.PageView)
        |> render("index.html", signup_changeset: changeset)
    end
  end
end
