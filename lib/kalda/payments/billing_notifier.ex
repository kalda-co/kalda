defmodule Kalda.Payments.BillingNotifier do
  import Bamboo.Email

  alias Kalda.Accounts.User

  defp base_email() do
    new_email()
    |> from("hello@kalda.co")
  end

  @spec subscription_created_email(User.t()) :: Bamboo.Email.t()
  def subscription_created_email(user) do
    body = """
    Thanks for subscribing to Kalda! Kalda provides mental health support for the LGBTQIA+ community. By subscribing you are committing to working on your mental health, and the mental wellbeing of your community. That’s powerful!

    You will now be able to access daily reflection questions, and weekly group therapy sessions.

    You subscribed today and you’ll pay £2.99 each month.

    If you want to cancel, email us at subscriptions@kalda.co.

    Thanks,
    The Kalda Team
    """

    base_email()
    |> subject("You have subscribed to Kalda")
    |> to(user.email)
    |> text_body(body)
  end
end
