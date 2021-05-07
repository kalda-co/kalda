defmodule KaldaWeb.Api.V1.UserView do
  alias Kalda.Accounts.User

  def render_author(author = %User{}) do
    %{
      id: author.id,
      username: author.username
    }
  end
end
