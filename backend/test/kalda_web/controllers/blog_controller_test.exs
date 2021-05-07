defmodule KaldaWeb.BlogControllerTest do
  use KaldaWeb.ConnCase

  for post <- Kalda.Blog.all_posts() do
    @post post
    test "Get /blog/#{@post.id}", %{conn: conn} do
      conn = get(conn, "/blog/#{@post.id}")
      assert html_response(conn, 200) =~ "kalda"
    end
  end
end
