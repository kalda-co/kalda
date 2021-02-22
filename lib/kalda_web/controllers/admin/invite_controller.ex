defmodule KaldaWeb.Admin.InviteController do
  use KaldaWeb, :controller
  alias Kalda.Accounts.Invite
  alias Kalda.Accounts
  alias Kalda.Policy

  def new(conn, _params) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    changeset = Invite.empty_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invite" => %{"email" => email}}) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    case Accounts.create_invite(email) do
      {:ok, {token, _invite}} ->
        Kalda.Accounts.UserNotifier.deliver_invite(email, token)

        conn
        |> put_flash(:info, "Invite created and email sent")
        |> redirect(to: Routes.admin_invite_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> render("new.html", changeset: changeset)
    end
  end
end
