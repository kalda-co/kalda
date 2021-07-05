defmodule KaldaWeb.Api.V1.StripePaymentIntentController do
  use KaldaWeb, :controller

  @spec create(any, any) :: none
  def create(conn, _params) do
    user = conn.assigns.current_user
    stripe_client = Map.get(conn.assigns, :stripe, Kalda.Payments.Stripe)
    subscription = Kalda.Payments.get_or_create_stripe_subscription!(user)

    conn
    |> put_status(201)
    |> render("show.json", client_secret: subscription.payment_intent_client_secret)
  end
end
