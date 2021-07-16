defmodule Kalda.PaymentsTest do
  use Kalda.DataCase, async: true
  alias Kalda.Payments
  alias Kalda.MockStripe
  alias Kalda.Accounts
  alias Kalda.AccountsFixtures
  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  @customer %Customer{stripe_id: "123"}
  @subscription %Subscription{stripe_id: "456", payment_intent_client_secret: "secret"}
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
      assert Accounts.get_user!(user.id).stripe_customer_id == "id"
    end

    test "customer with subscription" do
      MockStripe
      |> Hammox.expect(:get_customer!, 1, fn _ -> @subscribed_customer end)

      user = AccountsFixtures.user(stripe_customer_id: "id")
      assert Payments.get_or_create_stripe_subscription!(user, MockStripe) == @subscription
      assert Accounts.get_user!(user.id).stripe_customer_id == "id"
    end

    test "user has stripe customer id but no customer was found" do
      MockStripe
      |> Hammox.expect(:get_customer!, 1, fn _ -> nil end)
      |> Hammox.expect(:create_customer!, 1, fn _ -> @customer end)
      |> Hammox.expect(:create_subscription!, 1, fn _ -> @subscription end)

      user = AccountsFixtures.user(stripe_customer_id: "some-id")

      log =
        ExUnit.CaptureLog.capture_log(fn ->
          assert Payments.get_or_create_stripe_subscription!(user, MockStripe) == @subscription
        end)

      assert log =~
               "[warn] User #{user.id} had stripe customer id some-id but no customer was found"

      assert Accounts.get_user!(user.id).stripe_customer_id == @customer.stripe_id
    end
  end

  use Kalda.DataCase

  alias Kalda.Payments
  alias Kalda.PaymentsFixtures
  alias Kalda.AccountsFixtures

  describe "get_subscription_event_by_user_id/2" do
    test "does not return events that do not belong to user" do
      user = AccountsFixtures.user()
      user2 = AccountsFixtures.user()
      user3 = AccountsFixtures.user()
      event = PaymentsFixtures.subscription_event(user)
      event2 = PaymentsFixtures.subscription_event(user2)

      assert Payments.get_subscription_events_by_user_id(user.id) == [event]
      assert Payments.get_subscription_events_by_user_id(user2.id) == [event2]
      assert Payments.get_subscription_events_by_user_id(user3.id) == []
    end

    test "returns events in descending order with most recent first" do
      user = AccountsFixtures.user()
      event = PaymentsFixtures.past_subscription_event(user)
      event1 = PaymentsFixtures.subscription_event(user)

      assert Payments.get_subscription_events_by_user_id(user.id) == [event1, event]
    end

    test "limits the number of events retrieved if limit option passed" do
      user = AccountsFixtures.user()
      _event = PaymentsFixtures.past_subscription_event(user)
      _event1 = PaymentsFixtures.past_subscription_event(user)
      event1 = PaymentsFixtures.subscription_event(user)

      assert Payments.get_subscription_events_by_user_id(user.id, limit: 1) == [event1]
    end
  end

  describe "create_subscription_event" do
    test "creates an event for type 'stripe_subscription_created" do
      user = AccountsFixtures.user()

      assert subscription_event =
               %Payments.SubscriptionEvent{} =
               Kalda.Payments.create_subscription_event!(user, :stripe_subscription_created)

      assert subscription_event.name == :stripe_subscription_created
    end

    test "creates an event for type 'stripe_subscription_deleted" do
      user = AccountsFixtures.user()

      assert subscription_event =
               %Payments.SubscriptionEvent{} =
               Kalda.Payments.create_subscription_event!(user, :stripe_subscription_deleted)

      assert subscription_event.name == :stripe_subscription_deleted
    end

    test "does not create subscription_event for invalid event ENUM type" do
      user = AccountsFixtures.user()

      assert_raise Ecto.ChangeError, fn ->
        Kalda.Payments.create_subscription_event!(user, :subscriptghejwkfion_deleted)
      end
    end
  end
end
