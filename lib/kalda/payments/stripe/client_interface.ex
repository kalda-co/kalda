defmodule Kalda.Payments.Stripe.ClientInterface do
  @moduledoc """
  An interface for interacting with the Stripe API.
  A mock implementation is used in tests, the live API is called in prod.
  """
  alias Kalda.Accounts.User
  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  # Elixir has no typespec for modules
  @type t() :: module()
  @type subscription_id() :: String.t()
  @type payment_intent_id() :: String.t()
  @type payment_method() :: String.t()

  @callback get_customer!(String.t()) :: Customer.t() | nil
  @callback create_customer!(User.t()) :: Customer.t()
  @callback create_subscription!(Customer.t()) :: Subscription.t()
  @callback get_payment_intent_payment_method!(payment_intent_id()) :: payment_method()
  @callback set_subscription_payment_method!(subscription_id(), payment_method()) :: :ok
end
