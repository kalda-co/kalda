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

    Hello!

    We’re so excited to have you on the Kalda platform.

    Step 1: Complete your starting questionnaire
    The questionnaire helps us to understand what your needs are. We may share your questionnaire data with the group therapist, so they know how best to support you. We also use anonymised data from these questionnaires to measure the effectiveness of Kalda.

    http://docs.google.com/forms/d/1KsDnObaEsl6Y-1uIBnyXjDzIa36pz8a16DgsRFgsLUE/edit?usp=drive_web

    Step 2: Read these community guidelines

    No hateful language
    We will not tolerate any racist, sexist, homophobic, transphobic or other hate-speech or prejudiced or offensive language or behaviour within this group. If you see any hateful language press ‘report’, a moderator will remove it. If you say something that someone else deems offensive take that on board.

    Confidentiality
    Keep what is shared and discussed within the group confidential, don’t share it outside of the group. Keep the identities of members of the group private.

    Safety
    Kalda is not a crisis service. If you feel unable to keep yourself safe please click on the ‘Urgent Support’ button to access crisis services. If you feel someone else might be at risk of suicide inform one of our friendly Kalda moderators, rather than providing support to them yourself.

    Step 3: Create your account with this link

    If you agree to abide by the community guidelines above, you can now create your account by clicking on the link below:

    #{url}

    Step 4: Come along to group therapy
    Head over to the group therapy page in the app to learn about the next group therapy session - you’ll also be able to add these sessions to your Google calendar.

    Got any feedback?
    You can share your feedback at this link:

    https://form.jotform.com/210693702237049

    Thanks,
    Al, Daniel and Charlotte from the Kalda team


    ==============================
    """

    base_email()
    |> subject("Welcome to Kalda! Here is your personal invite link")
    |> to(email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end

  def deliver_referral_link(email, name, expires_at, referring_slots) do
    url = KaldaWeb.Router.Helpers.referral_url(KaldaWeb.Endpoint, :show, name)

    body = """
    ==============================

    Hello!
    Thank you for being a Kalda SuperSquid and sharing the Kalda love.

    You can now share Kalda with up to #{referring_slots} of your friends or followers! They can create a Kalda account by clicking on the link below:

    #{url}

    For the safety of the whole community, this link will expire on #{expires_at}.

    If you need more referral links just email support@kalda.co.
    ==============================
    """

    base_email()
    |> subject("Here is your Kalda referral link")
    |> to(email)
    |> text_body(body)
    |> Kalda.Mailer.deliver_now()
  end
end
