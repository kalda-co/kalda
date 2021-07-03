defmodule Kalda.Payments.Stripe.Interface do
  @moduledoc """
  An interface for interacting with the Stripe API.

  A mock implementation is used in tests, the live API is called in prod.
  """
  alias Kalda.Accounts.User
  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  # Elixir has no typespec for modules
  @type t() :: atom()

  @callback get_customer!(String.t()) :: Customer.t() | nil
  @callback create_customer!(User.t()) :: Customer.t()
  @callback create_subscription!(Customer.t()) :: Subscription.t()
end
