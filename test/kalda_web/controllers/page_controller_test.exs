defmodule KaldaWeb.PageControllerTest do
  use KaldaWeb.ConnCase

  test "Get /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "kalda"
  end
end
