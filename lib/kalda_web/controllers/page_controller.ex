defmodule KaldaWeb.PageController do
  use KaldaWeb, :controller

  plug :put_root_layout, {KaldaWeb.LayoutView, :site_page}

  def index(conn, _params) do
    conn.assigns.current_user

    conn
    |> render("index.html")
  end

  def thanks(conn, _params) do
    conn
    |> render("thanks.html")
  end

  def privacy_policy(conn, _params) do
    conn
    |> render("privacy_policy.html")
  end
end
