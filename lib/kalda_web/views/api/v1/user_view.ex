defmodule KaldaWeb.Api.V1.UserView do
  alias Kalda.Accounts.User

  # def render_author(author = %User{}) do
  #   %{
  #     id: author.id,
  #     username: author.username,
  #     has_subscription: true
  #   }
  # end

  def render_author(author = %User{}) do
    %{
      id: author.id,
      username: author.username,
      has_subscription: Kalda.Accounts.has_subscription?(author)
    }
  end

  def render_user(user = %User{}) do
    %{
      id: user.id,
      username: user.username,
      has_subscription: Kalda.Accounts.has_subscription?(user)
    }
  end
end
