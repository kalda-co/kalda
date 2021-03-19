defmodule KaldaWeb.Admin.ReferralController do
  use KaldaWeb, :controller
  alias Kalda.Accounts.Referral
  alias Kalda.Accounts.User
  alias Kalda.Accounts
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_referrals, Kalda)
    referrals = Accounts.get_referrals(preload: [:referrer])
    render(conn, "index.html", referrals: referrals)
  end

  def new(conn, _params) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    changeset = Referral.empty_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  # needs to create for a USER(email) and a name
  # Form inputs are the email address of the peson you create the referral for and then the name for the link and expires at and referring slots
  # TODO: possible date conversion required
  def create(conn, %{
        "referral" => %{
          "email" => email,
          "name" => name,
          "expires_at" => expires_at,
          "referring_slots" => referring_slots
        }
      }) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    referral_params = %{name: name, expires_at: expires_at, referring_slots: referring_slots}
    # case get user by email, ok user -> create referral with name
    case Accounts.get_user_by_email(email) do
      %User{} = user ->
        case Accounts.create_referral(user, referral_params) do
          {:ok, _referral} ->
            Kalda.Accounts.UserNotifier.deliver_referral_link(
              email,
              name,
              expires_at,
              referring_slots
            )

            referral_link = KaldaWeb.Router.Helpers.referral_url(KaldaWeb.Endpoint, :show, name)

            conn
            |> put_flash(:info, "Referral created #{referral_link}, and email sent")
            |> redirect(to: Routes.admin_referral_path(conn, :new))

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(422)
            |> put_flash(:warning, "Are you sure this email belongs to a user?")
            |> render("new.html", changeset: changeset)
        end

      nil ->
        changeset = Referral.changeset(%Referral{}, referral_params)

        conn
        |> put_status(422)
        |> put_flash(:error, "No user exists that matches this email")
        |> render("new.html", changeset: changeset)
    end
  end
end
