defmodule KaldaWeb.Admin.ReferralLinkController do
  use KaldaWeb, :controller
  alias Kalda.Accounts.ReferralLink
  alias Kalda.Accounts.User
  alias Kalda.Accounts
  alias Kalda.Policy

  def index(conn, _params) do
    Policy.authorize!(conn, :view_referrals, Kalda)
    referral_links = Accounts.get_referrals(preload: [:referrer])
    render(conn, "index.html", referral_links: referral_links)
  end

  def new(conn, _params) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)
    changeset = ReferralLink.empty_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  # needs to create for a USER(email) and a name
  # Form inputs are the email address of the peson you create the referral_link for and then the name for the link and expires at and referring slots
  # TODO: possible date conversion required
  def create(conn, %{
        # "referral_link" => %{
        #   "email" => email,
        #   "name" => name,
        #   "expires_at" => expires_at,
        #   "referring_slots" => referring_slots
        # }
        "referral_link" => referral_link_params
      }) do
    Policy.authorize!(conn, :view_admin_pages, Kalda)

    # referral_link_params => %{name: name, expires_at: expires_at, referring_slots: referring_slots}
    # case get user by email, ok user -> create referral_link with name
    case Accounts.get_user_by_email(referral_link_params["email"]) do
      %User{} = user ->
        case Accounts.create_referral(user, referral_link_params) do
          {:ok, _referral} ->
            Kalda.Accounts.UserNotifier.deliver_referral_link(
              referral_link_params["email"],
              referral_link_params["name"],
              referral_link_params["expires_at"],
              referral_link_params["referring_slots"]
            )

            referral_link =
              KaldaWeb.Router.Helpers.referral_link_url(
                KaldaWeb.Endpoint,
                :show,
                referral_link_params["name"]
              )

            conn
            |> put_flash(:info, "ReferralLink created #{referral_link}, and email sent")
            |> redirect(to: Routes.admin_referral_link_path(conn, :new))

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(422)
            |> put_flash(:error, "Please check the errors below")
            |> render("new.html", changeset: changeset)
        end

      nil ->
        changeset = ReferralLink.changeset(%ReferralLink{}, referral_link_params)

        conn
        |> put_status(422)
        |> put_flash(:error, "No user exists that matches this email")
        |> render("new.html", changeset: changeset)
    end
  end
end
