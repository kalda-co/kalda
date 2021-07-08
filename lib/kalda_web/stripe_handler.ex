defmodule KaldaWeb.StripeHandler do
  @behaviour Stripe.WebhookHandler
  # Your event handler module should implement the `Stripe.WebhookHandler`
  # behavior, defining a `handle_event/1` function which takes a `Stripe.Event`
  # struct and returns either `{:ok, term}` or `:ok`

  @impl true
  def handle_event(%Stripe.Event{type: "invoice.payment_succeeded"} = event) do
    # TODO: handle the event
    # TODO: to test this we could use an interface so that these API calls take either the Stripe module or a mock.

    if event.data.object.billing_reason == "subscription_create" do
      # stripe_customer_id = event.data.object.customer
      subscription_id = event.data.object.subscription
      payment_intent_id = event.data.object.payment_intent

      # Request to Stripe Api to retrieve the payment_intent
      # TODO: handle failure to connect etc
      {:ok, payment_intent} = Stripe.PaymentIntent.retrieve(payment_intent_id, %{})

      # Send request to API to set above method as the DEFAULT for recurring subscription events:
      {:ok, _subscription} =
        Stripe.Subscription.update(subscription_id, %{
          default_payment_method: payment_intent.payment_method
        })
    end

    # TODO:
    # Get user by stripe_customer_id
    # update User with subscription info, such as has_stripe_subscription and possibly the subscription_expires_at???
    # Also consider storing: Product_id, (current_)subscriptions_id, (stripe_)subscription_status (should this repleace has_subscription??) and subscription_price
    # TODO: update subscription_events log/table
    :ok
  end

  @impl true
  def handle_event(%Stripe.Event{type: "customer.subscription.updated "} = _event) do
    # TODO: handle the event
    # IO.inspect(event)

    # TODO: of particular concern here is payment failure
    # Also consider storing/updating: Product_id, (current_)subscriptions_id, (stripe_)subscription_status (should this repleace has_subscription??) and subscription_price
    # TODO: update subscription_events log/table
    :ok
  end

  # Return HTTP 200 for unhandled events
  @impl true
  def handle_event(_event) do
    # IO.inspect(event)
    # TODO: consider storing in an event_log with customer_id if present
    :ok
  end
end
