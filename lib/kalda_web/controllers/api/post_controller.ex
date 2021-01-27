defmodule KaldaWeb.Api.PostController do
  use KaldaWeb, :controller

  alias Kalda.Forums

  def index(conn, _params) do
    posts = Forums.get_posts()
    json(conn, %{data: posts})
  end
end
