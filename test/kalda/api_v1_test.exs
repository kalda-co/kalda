defmodule KaldaWeb.Api.V1.Test do
  use KaldaWeb.ConnCase

  # alias Kalda.Api.V1
  # alias Kalda.Api.V1.Post

  # alias Kalda.Forums
  # alias Kalda.Forums.Post
  # alias Kalda.AccountsFixtures

  # @create_post_attrs %{content: "post content"}
  # @update_attrs %{content: "some updated content"}
  # @invalid_attrs %{content: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.api_post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  # describe "create post" do
  #   test "renders post when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.api_post_path(conn, :create), post: @create_post_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.api_post_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "content" => "oist content"
  #            } = json_response(conn, 200)["data"]
  #   end
  # end
end
