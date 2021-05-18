defmodule KaldaWeb.Api.V1.SessionView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{user: user}) do
    %{
      user: UserView.render_user(user),
      csrf_token: Plug.CSRFProtection.get_csrf_token()
    }
  end
end
