defmodule Kalda.Payments.Stripe.Customer do
  use Ecto.Schema
  alias Kalda.Payments.Stripe.Subscription

  @type t() :: %__MODULE__{
          stripe_id: String.t(),
          subscription: nil | Subscription.t()
        }

  @primary_key false
  embedded_schema do
    field :stripe_id, :string, null: false
    embeds_one :subscription, Subscription
  end

  @spec from_stripe_payload(Stripe.Customer.t()) :: t()
  def from_stripe_payload(customer = %Stripe.Customer{}) do
    subscriptions =
      case customer.subscriptions do
        %{data: [subscription | _]} -> Subscription.from_stripe_payload(subscription)
        _ -> nil
      end

    %__MODULE__{
      stripe_id: customer.id,
      subscription: subscriptions
    }
  end
end
