defmodule KaldaWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView
  alias Kalda.Accounts
  alias KaldaWeb.Router.Helpers, as: Routes

  @doc """
  Renders a component inside the `KaldaWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, KaldaWeb.PostLive.FormComponent,
        id: @post.id || :new,
        action: @live_action,
        post: @post,
        return_to: Routes.post_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, KaldaWeb.ModalComponent, modal_opts)
  end

  @doc """
  Assign the current user to the LiveView socket so it xan be used in the LiveView code.
  If there is no logged in user halt and redirect to the login page.
  """
  def assign_current_user(socket, session) do
    # Get the current user (if there is one) and assign it to the socket
    get_user = fn -> Accounts.get_user_by_session_token(session["user_token"]) end
    socket = assign_new(socket, :user, get_user)

    # Check to see if the user was assigned
    case socket.assigns.user do
      # There is a user, so we are logged int
      %Kalda.Accounts.User{} ->
        socket

      # There is no user, we are not logged in. Redirect to the login page.
      _no_user ->
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: Routes.user_session_path(socket, :new))
    end
  end
end
