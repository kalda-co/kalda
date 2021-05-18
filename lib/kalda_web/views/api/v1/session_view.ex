defmodule KaldaWeb.Api.V1.SessionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{user: user, user_token: user_token}) do
    %{
      user: UserView.render_user(user),
      user_token: user_token,
      csrf_token: Plug.CSRFProtection.get_csrf_token()
    }
  end
end
