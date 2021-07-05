defmodule Kalda.Payments.Stripe do
  @behaviour Kalda.Payments.Stripe.Interface

  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  @impl true
  def get_customer!(stripe_customer_id) do
    case Stripe.Customer.retrieve(stripe_customer_id,
           expand: ["subscriptions.data.latest_invoice.payment_intent"]
         ) do
      {:ok, customer} -> Customer.from_stripe_payload(customer)
      {:error, %{extra: %{http_status: 404}}} -> nil
    end
  end

  @impl true
  def create_customer!(user) do
    {:ok, customer} = Stripe.Customer.create(%{email: user.email})
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

    import Stripe.Request

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
end
