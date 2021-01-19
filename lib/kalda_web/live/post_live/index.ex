defmodule KaldaWeb.PostLive.Index do
  use KaldaWeb, :live_view

  alias Kalda.Forums

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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Geting Posts")
    |> assign(:post, nil)
  end

  defp get_posts do
    Forums.get_posts()
  end
end
