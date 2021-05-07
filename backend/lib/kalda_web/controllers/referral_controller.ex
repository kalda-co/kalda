defmodule KaldaWeb.ReferralLinkController do
  use KaldaWeb, :controller
  alias Kalda.Accounts
  alias Kalda.Accounts.User
  alias Kalda.Accounts.ReferralLink

  def show(conn, %{"name" => name}) do
    case Accounts.get_referral_link_by_name(name) do
      nil ->
        render(conn, "expired.html")

      referral_link ->
        changeset = ReferralLink.empty_changeset()
        render(conn, "show.html", referral_link: referral_link, changeset: changeset, name: name)
    end
  end

  def create(conn, %{"user" => params}) do
    name = params["name"]

    case Accounts.create_user_from_referral(name, params) do
      {:ok, %User{} = user} ->
        Accounts.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :confirm, &1)
        )

        conn
        |> put_flash(
          :info,
          "User created successfully. Please check your email for confirmation instructions"
        )
        # |> KaldaWeb.UserAuth.log_in_user(user)
        |> redirect(to: Routes.user_confirmation_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        referral_link = Accounts.get_referral_link_by_name(name)
        render(conn, "show.html", changeset: changeset, referral_link: referral_link, name: name)

      :expired ->
        conn
        |> render("expired.html")

      :not_found ->
        conn
        |> render("expired.html")
    end
  end
end
