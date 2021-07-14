defmodule KaldaWeb.StripeWebhookHandler do
  @moduledoc """
  A handler for webhooks from Stripe that let us know when the status of
  subscriptions has changed.

  Test with `stripe listen --forward-to localhost:3000/webhook/stripe`
  """
  @behaviour Stripe.WebhookHandler
  require Logger
  alias Kalda.Accounts
  alias Kalda.Payments.Stripe.ClientInterface

  @spec handle_event(Stripe.Event.t()) :: :ok
  def handle_event(event) do
    Logger.info("Stripe webhook #{event.type}")
    handle(event, Kalda.Payments.Stripe.Client)
  end

  # TODO: test
  @spec handle(Stripe.Event.t(), ClientInterface.t()) :: :ok
  def handle(
        %Stripe.Event{
          type: "invoice.payment_succeeded",
          data: %{
            object: %Stripe.Invoice{
              billing_reason: "subscription_create",
              subscription: subscription_id,
              payment_intent: payment_intent_id,
              customer: customer_id
            }
          }
        },
        stripe
      )
      when is_binary(subscription_id) and is_binary(payment_intent_id) and is_binary(customer_id) do
    Kalda.Repo.transaction!(fn ->
      # Record that this user has a Stripe subscription
      user = Accounts.get_user_by_stripe_customer_id!(customer_id)
      Accounts.add_stripe_subscription!(user)

      # Set this payment method used by this payment as the default one to be
      # used by this subscription in future
      payment_method = stripe.get_payment_intent_payment_method!(payment_intent_id)
      stripe.set_subscription_payment_method!(subscription_id, payment_method)

      # TODO: update subscription_events log/table
      Logger.info("Stripe subscription added for user:#{user.id}")
    end)

    :ok
  end

  def handle(%Stripe.Event{type: "customer.subscription.updated"}, _stripe) do
    # TODO: Remove stripe subscription if a subscription is cancelled
    :ok
  end

  # Return HTTP 200 for events we don't care about
  def handle(_event, _stripe) do
    # TODO: Handle a payment failing to go through
    :ok
  end
end
