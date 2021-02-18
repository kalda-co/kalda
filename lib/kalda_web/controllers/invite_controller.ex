defmodule KaldaWeb.InviteController do
  use KaldaWeb, :controller

  def show(conn, %{"token" => token}) do
    invite = Kalda.Accounts.get_invite_for_token(token)
    render(conn, "show.html", invite: invite)
  end
end
