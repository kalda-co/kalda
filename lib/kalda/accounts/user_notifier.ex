defmodule Kalda.Accounts.UserNotifier do
  import Bamboo.Email

  defp base_email() do
    new_email()
    |> from("hello@kalda.co")
  end

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  # defp deliver(to, body) do
  #   require Logger
  #   Logger.debug(body)
  #   {:ok, %{to: to, body: body}}
  # end

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
end
