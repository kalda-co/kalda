defmodule Kalda.Policy do
  @moduledoc """
  Rules engine for authorization. Used to check whether an entity has
  permission to do something.
  """
  alias Kalda.Accounts.User

  defmodule UnauthorizedError do
    defexception [:message]

    @impl true
    def exception(_value) do
      %__MODULE__{message: "The user does not have permission to perform this action"}
    end
  end

  def authorize!(%Plug.Conn{assigns: %{current_user: user}}, action, subject) do
    authorize!(user, action, subject)
  end

  # Gives admin authorization to do anything
  def authorize!(%User{is_admin: true}, _any_action, _any_subject), do: true

  def authorize!(_user, action, Kalda)
      when action in [
             :view_admin_posts,
             :create_admin_post,
             :view_admin_post,
             :edit_admin_post,
             :delete_admin_post,
             :api_view_posts
           ] do
    raise UnauthorizedError
  end

  # Authorizes access for subscription-only content
  def authorize!(%User{} = user, :view_subscription_content, Kalda),
    do: Kalda.Accounts.has_subscription?(user)

  # When authorization is required but user has none
  def authorize!(%User{} = _user, _action, _subject) do
    raise UnauthorizedError
  end

  # Catches exception in production.
  defimpl Plug.Exception, for: Kalda.Policy.UnauthorizedError do
    def status(_exception), do: 404
    def actions(_exception), do: []
  end
end
