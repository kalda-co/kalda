defmodule Kalda.Policy do
  @moduledoc """
  Rules engine for authorization. Used to check whether a entity has
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
             :view_admin_pages,
             :create_post
             #  :view_admin_menu,
             # :view_all_users,
             #  :delete_comment,
             #  :delete_reply
           ] do
    raise UnauthorizedError
  end

  # def authorize!(%User{} = user, :edit_paper, %Collaboration{} = collaboration) do
  #   if user.id != collaboration.user_id || !collaboration.can_edit do
  #     raise UnauthorizedError
  #   end
  # end

  # SHorthand version:
  # def authorize!(%User{id: user_id}, :edit_paper, %Collaboration{can_edit: true, user_id: user_id}) do
  #   :ok
  # end

  def authorize!(%User{} = _user, _action, _subject) do
    raise UnauthorizedError
  end

  # TODO test
  def can?(user, action, subject) do
    authorize!(user, action, subject)
    true
  rescue
    Kalda.Policy.UnauthorizedError -> false
  end
end

# Catches exception in production.
defimpl Plug.Exception, for: Kalda.Policy.UnauthorizedError do
  def status(_exception), do: 404
  def actions(_exception), do: []
end
