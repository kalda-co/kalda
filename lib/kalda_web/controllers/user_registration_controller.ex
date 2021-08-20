defmodule KaldaWeb.UserRegistrationController do
  use KaldaWeb, :controller

  alias Kalda.Accounts
  alias Kalda.Accounts.User
  alias Kalda.EmailLists

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user_without_free_subscription(user_params) do
      {:ok, user} ->
        Accounts.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :confirm, &1)
        )

        # Tries to add to sendfox user freemium list
        # TODO: Test that error logs if fails is captured by Rollbar
        list_id = Application.get_env(:kalda, :sendfox_freemium_id)
        EmailLists.register_with_sendfox(user.email, list_id)

        conn
        |> put_flash(
          :info,
          "Success. Please check your emails and click the link to confirm your account."
        )
        |> render("show.html")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
