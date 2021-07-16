defmodule Kalda.Payments.Stripe.Client do
  @behaviour Kalda.Payments.Stripe.ClientInterface

  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription
  alias Stripe, as: StripeLib

  @impl true
  def get_customer!(stripe_customer_id) do
    case StripeLib.Customer.retrieve(stripe_customer_id,
           expand: ["subscriptions.data.latest_invoice.payment_intent"]
         ) do
      {:ok, customer} -> Customer.from_stripe_payload(customer)
      {:error, %{extra: %{http_status: 404}}} -> nil
    end
  end

  @impl true
  def create_customer!(user) do
    {:ok, customer} = StripeLib.Customer.create(%{email: user.email})
    Customer.from_stripe_payload(customer)
  end

  @impl true
  def create_subscription!(customer) do
    price_id =
      Application.get_env(:kalda, :stripe_subscription_price_id) ||
        raise "stripe_subscription_price_id not found in kalda app env"

    params = %{
      customer: customer.stripe_id,
      payment_behavior: "default_incomplete",
      expand: ["latest_invoice.payment_intent"],
      items: [%{price: price_id}]
    }

    import StripeLib.Request

    response =
      new_request([])
      |> put_endpoint("subscriptions")
      |> put_params(params)
      |> put_method(:post)
      |> cast_to_id([:coupon, :customer])
      |> make_request()

    # TODO: failure paths
    case response do
      {:ok, subscription} -> Subscription.from_stripe_payload(subscription)
    end
  end

  @impl true
  def get_payment_intent_payment_method!(payment_intent_id) do
    {:ok, payment_intent} = StripeLib.PaymentIntent.retrieve(payment_intent_id, %{})
    payment_intent.payment_method
  end

  @impl true
  def set_subscription_payment_method!(subscription_id, payment_method) do
    StripeLib.Subscription.update(subscription_id, %{
      default_payment_method: payment_method
    })

    :ok
  end
end
