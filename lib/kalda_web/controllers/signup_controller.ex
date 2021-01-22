defmodule KaldaWeb.SignupController do
  use KaldaWeb, :controller

  alias Kalda.Waitlist
  alias Kalda.Waitlist.Signup

  def index(conn, _params) do
    signups = Waitlist.list_signups()
    render(conn, "index.html", signups: signups)
  end

  def new(conn, _params) do
    changeset = Waitlist.change_signup(%Signup{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"signup" => signup_params}) do
    case Waitlist.create_signup(signup_params) do
      {:ok, signup} ->
        Waitlist.sendfox_post_request!(signup.email)

        conn
        |> put_flash(:info, "Signup created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
