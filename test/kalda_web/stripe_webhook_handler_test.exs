defmodule KaldaWeb.StripeWebhookHandlerTest do
  use Kalda.DataCase, async: true
  import ExUnit.CaptureLog, only: [capture_log: 1]

  setup ctx do
    Hammox.verify_on_exit!(ctx)
  end

  @payment_intent_id "payment-intent-3af9630f-9f30-4863-af71-75497521333f"
  @payment_method "payment-method-6653b865-9e83-4c93-8f72-ec735bd15c4f"
  @subscription_id "subscription-id-431e1ee4-8009-48c8-8033-3366ce6a30cf"
  @customer_id "customer-id-9e8b27c5-450a-4747-a41c-d3b8ea80fb45"

  test "invoice.payment_succeeded -> billing_reason: subscription_create" do
    Kalda.MockStripe
    |> Hammox.expect(:get_payment_intent_payment_method!, 1, fn @payment_intent_id ->
      @payment_method
    end)
    |> Hammox.expect(:set_subscription_payment_method!, 1, fn @subscription_id, @payment_method ->
      :ok
    end)

    user = Kalda.AccountsFixtures.user(%{stripe_customer_id: @customer_id})
    refute user.has_stripe_subscription

    event = %Stripe.Event{
      type: "invoice.payment_succeeded",
      data: %{
        object: %Stripe.Invoice{
          billing_reason: "subscription_create",
          subscription: @subscription_id,
          payment_intent: @payment_intent_id,
          customer: @customer_id
        }
      }
    }

    log =
      capture_log(fn ->
        assert :ok = KaldaWeb.StripeWebhookHandler.handle(event, Kalda.MockStripe)
        assert Kalda.Accounts.get_user!(user.id).has_stripe_subscription
      end)

    assert log =~ "[info] Stripe subscription added for user:#{user.id}"
  end
end
