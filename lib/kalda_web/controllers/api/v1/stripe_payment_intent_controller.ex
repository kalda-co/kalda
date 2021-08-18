defmodule KaldaWeb.Api.V1.StripePaymentIntentController do
  use KaldaWeb, :controller

  @doc """
  In order to test stripe transactions, use the stripe CLI:
  ```sh
  stripe login
  stripe listen --forward-to localhost:4000/webhook/stripe
  ```
  Ensure that the dev_secrets signing secret is up to date.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, _params) do
    user = conn.assigns.current_user
    stripe_client = Map.get(conn.assigns, :stripe, Kalda.Payments.Stripe.Client)
    subscription = Kalda.Payments.get_or_create_stripe_subscription!(user, stripe_client)

    conn
    |> put_status(201)
    |> render("show.json", client_secret: subscription.payment_intent_client_secret)
  end
end
