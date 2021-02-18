defmodule KaldaWeb.Admin.InviteController do
  use KaldaWeb, :controller
  alias Kalda.Accounts.Invite
  alias Kalda.Accounts
  alias Kalda.Policy

  def new(conn, _params) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    changeset = Invite.changeset(%Invite{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invite" => %{"email" => email}}) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    case Accounts.create_invite(email) do
      {:ok, {token, _invite}} ->
        Kalda.Accounts.UserNotifier.deliver_invite(email, token)
        changeset = Invite.changeset(%Invite{}, %{})

        conn
        |> put_flash(:info, "Invite created and email sent")
        |> render("new.html", changeset: changeset)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   Policy.authorize!(conn, :view_admin_pages, Kalda)
  #   invite = Accounts.get_invite!(id)
  #   render(conn, "show.html", invite: invite)
  # end
end
