defmodule KaldaWeb.PageController do
  use KaldaWeb, :controller

  alias Kalda.EmailLists
  alias Kalda.EmailLists.Signup

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def index(conn, _params) do
    changeset = EmailLists.change_signup(%Signup{})
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
    changeset = EmailLists.change_signup(%Signup{})
    render(conn, "terms.html", signup_changeset: changeset)
  end

  # TODO: move to its own controller that pre-seeds data as required
  def app(conn, _params) do
    conn
    |> put_layout(false)
    |> put_root_layout(false)
    |> render("app.html")
  end
end
