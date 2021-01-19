defmodule KaldaWeb.PostLive.Index do
  use KaldaWeb, :live_view

  alias Kalda.Forums
  alias Kalda.Forums.Post

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, assign(socket, :posts, get_posts())}
    {:ok,
     socket
     |> assign(posts: get_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # Index
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Daily Reflections")
    |> assign(:post, nil)
  end

  # New
  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Daily Reflections")
    |> assign(:post, %Post{})
  end

  defp get_posts do
    Forums.get_posts()
  end
end
