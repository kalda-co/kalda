defmodule KaldaWeb.PostLive.Index do
  use KaldaWeb, :live_view

  alias Kalda.Accounts
  alias Kalda.Forums
  alias Kalda.Forums.Post

  @impl true
  def mount(params, session, socket) do
    # {:ok, assign(socket, :posts, get_posts())}
    socket =
      socket
      |> assign_current_user(session)
      |> assign(posts: get_posts())

    {:ok, socket}
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

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Forums.get_post!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Forums.get_post!(id)
    {:ok, _} = Forums.delete_post(post)

    {:noreply, assign(socket, :posts, get_posts())}
  end

  defp get_posts do
    Forums.get_posts()
  end
end
