defmodule Kalda.PaymentsTest do
  use Kalda.DataCase, async: true
  alias Kalda.Payments
  alias Kalda.MockStripe
  alias Kalda.Accounts
  alias Kalda.AccountsFixtures
  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  @customer %Customer{stripe_id: "123"}
  @subscription %Subscription{stripe_id: "456"}
  @subscribed_customer %Customer{@customer | subscription: @subscription}

  setup ctx do
    Hammox.verify_on_exit!(ctx)
  end

  describe "get_or_create_stripe_subscription!" do
    test "new customer" do
      MockStripe
      |> Hammox.expect(:create_customer!, 1, fn _ -> @customer end)
      |> Hammox.expect(:create_subscription!, 1, fn _ -> @subscription end)

      user = AccountsFixtures.user(stripe_customer_id: nil)
      assert Payments.get_or_create_stripe_subscription!(user, MockStripe) == @subscription
      assert Accounts.get_user!(user.id).stripe_customer_id != nil
    end

    test "customer with no subscription" do
      MockStripe
      |> Hammox.expect(:get_customer!, 1, fn _ -> @customer end)
      |> Hammox.expect(:create_subscription!, 1, fn _ -> @subscription end)

      user = AccountsFixtures.user(stripe_customer_id: "id")
      assert Payments.get_or_create_stripe_subscription!(user, MockStripe) == @subscription
    end

    test "customer with subscription" do
      MockStripe
      |> Hammox.expect(:get_customer!, 1, fn _ -> @subscribed_customer end)

      user = AccountsFixtures.user(stripe_customer_id: "id")
      assert Payments.get_or_create_stripe_subscription!(user, MockStripe) == @subscription
    end
  end
end
