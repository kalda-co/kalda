defmodule Kalda.Accounts.UserNotifier do
  import Bamboo.Email

  defp base_email() do
    new_email()
    |> from("hello@kalda.co")
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    body = """
    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    Thanks,
    Team Kalda
    """

    base_email()
    |> subject("Confirm your Kalda account")
    |> to(user.email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    body = """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    base_email()
    |> subject("Password reset instructions")
    |> to(user.email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    body = """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    base_email()
    |> subject("Change your email instructions")
    |> to(user.email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end

  def deliver_invite(email, token) do
    url = KaldaWeb.Router.Helpers.invite_url(KaldaWeb.Endpoint, :show, token)

    body = """
    ==============================

    Congratulations! You can join the Kalda revolution:

    Create your account by clicking on the link below:

    #{url}

    If you didn't request this, please ignore.

    ==============================
    """

    base_email()
    |> subject("Welcome to Kalda! Here is your personal invite link")
    |> to(user.email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end
end
