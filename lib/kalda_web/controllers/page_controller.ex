defmodule KaldaWeb.PageController do
  use KaldaWeb, :controller

  alias Kalda.Waitlist
  alias Kalda.Waitlist.Signup

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def index(conn, _params) do
    changeset = Waitlist.change_signup(%Signup{})
    render(conn, "index.html", signup_changeset: changeset)
  end

  def thanks(conn, _params) do
    conn
    |> render("thanks.html")
  end

  def privacy_policy(conn, _params) do
    conn
    |> render("privacy_policy.html")
  end

  def terms(conn, _params) do
    conn
    |> render("terms.html")
  end
end
