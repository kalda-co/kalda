defmodule Kalda.Payments do
  @moduledoc """
  The Payments context.
  """

  alias Kalda.Accounts.User
  alias Kalda.Payments.Stripe

  @doc """
  Get the stripe customer for a user if it exists. Alternatively create a new
  stripe customer using the Stripe API and insert it into our database.
  """
  @spec get_or_create_stripe_subscription!(User.t(), Stripe.Interface.t()) ::
          Stripe.Subscription.t()
  def get_or_create_stripe_subscription!(user = %User{}, stripe \\ Stripe) do
    customer = get_or_create_stripe_customer(user, stripe)

    case customer.subscription do
      nil -> stripe.create_subscription!(customer)
      subscription -> subscription
    end
  end

  # Get the stripe customer for a user if it exists. Alternatively create a new
  # stripe customer using the Stripe API.
  @spec get_or_create_stripe_customer(User.t(), Stripe.Interface.t()) :: Stripe.Customer.t()
  defp get_or_create_stripe_customer(user = %User{}, stripe) do
    case get_stripe_customer(user, stripe) do
      nil -> user |> Map.put(:stripe_customer_id, nil) |> create_stripe_customer(stripe)
      customer -> customer
    end
  end

  # Fetch a customer from the Stripe API
  @spec get_stripe_customer(User.t(), Stripe.Interface.t()) :: Stripe.Customer.t() | nil
  defp get_stripe_customer(user = %User{}, stripe) do
    case user.stripe_customer_id do
      nil -> nil
      id -> stripe.get_customer!(id)
    end
  end

  # Create a new stripe customer using the Stripe API and record it in the
  # database.
  # Errors if the user already has a stripe customer id.
  @spec create_stripe_customer(User.t(), Stripe.Interface.t()) :: StripeCustomer.t()
  defp create_stripe_customer(user = %User{stripe_customer_id: id}, stripe)
       when is_nil(id) do
    customer = stripe.create_customer!(user)

    user
    |> Ecto.Changeset.change(stripe_customer_id: customer.stripe_id)
    |> Kalda.Repo.update!()

    customer
  end
end
