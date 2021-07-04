defmodule Kalda.Payments.Stripe.Subscription do
  use Ecto.Schema

  @type t() :: %__MODULE__{
          stripe_id: String.t(),
          payment_intent_client_secret: String.t()
        }

  @primary_key false
  embedded_schema do
    field :stripe_id, :string, null: false
    field :payment_intent_client_secret, :string, null: false
  end

  @spec from_stripe_payload(Stripe.Subscription.t()) :: t()
  def from_stripe_payload(subscription = %Stripe.Subscription{}) do
    client_secret = subscription.latest_invoice.payment_intent.client_secret

    %__MODULE__{
      stripe_id: subscription.id,
      payment_intent_client_secret: client_secret
    }
  end
end
