defmodule Kalda.Payments.Stripe.Subscription do
  use Ecto.Schema

  @type t() :: %__MODULE__{
<<<<<<< HEAD
          stripe_id: String.t(),
          payment_intent_client_secret: String.t()
=======
          stripe_id: String.t()
>>>>>>> 80fd8ca (wip)
        }

  @primary_key false
  embedded_schema do
    field :stripe_id, :string, null: false
<<<<<<< HEAD
    field :payment_intent_client_secret, :string, null: false
  end

  @spec from_stripe_payload(Stripe.Subscription.t()) :: t()
  def from_stripe_payload(subscription = %Stripe.Subscription{}) do
    %__MODULE__{
      stripe_id: subscription.id,
      payment_intent_client_secret: subscription.latest_invoice.payment_intent.client_secret
=======
  end

  def from_stripe_payload(customer = %Stripe.Subscription{}) do
    %__MODULE__{
      stripe_id: customer.id
>>>>>>> 80fd8ca (wip)
    }
  end
end
