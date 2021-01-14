defmodule KaldaWeb.PageController do
  use KaldaWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def thanks(conn, _params) do
    conn
    |> render("thanks.html")
  end
end
