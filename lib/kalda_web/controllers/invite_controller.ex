defmodule KaldaWeb.InviteController do
  use KaldaWeb, :controller
  alias Kalda.Accounts
  alias Kalda.Accounts.User
  alias Kalda.Accounts.Invite

  def show(conn, %{"token" => token}) do
    case Accounts.get_invite_for_token(token) do
      nil ->
        render(conn, "expired.html")

      invite ->
        changeset = Invite.changeset(%Invite{token: token}, %{})
        render(conn, "show.html", invite: invite, changeset: changeset)
    end
  end

  def create(conn, %{"user" => params}) do
    token = params["token"]

    case Accounts.create_user_from_invite(token, params) do
      {:ok, %User{} = user} ->
        conn
        |> put_flash(:info, "Account created successfully")
        |> KaldaWeb.UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        invite = Accounts.get_invite_for_token(token)
        render(conn, "show.html", changeset: changeset, invite: invite)
    end
  end
end
