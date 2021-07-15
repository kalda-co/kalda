defmodule Kalda.Payments do
  @moduledoc """
  The Payments context.
  """

  require Logger
  alias Kalda.Accounts.User
  alias Kalda.Payments.Stripe
  alias Kalda.Payments.BillingNotifier
  import Ecto.Query, warn: false
  alias Kalda.Repo
  alias Kalda.Payments.SubscriptionEvent

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
      # Here the user has a customer id but the stripe API returned no customer.
      # The customer must have been deleted in the stripe admin console
      nil when user.stripe_customer_id != nil ->
        sid = user.stripe_customer_id
        Logger.warn("User #{user.id} had stripe customer id #{sid} but no customer was found")
        user |> Map.put(:stripe_customer_id, nil) |> create_stripe_customer(stripe)

      nil ->
        create_stripe_customer(user, stripe)

      customer ->
        customer
    end
  end

  # Fetch a customer from the Stripe API
  @spec get_stripe_customer(User.t(), Stripe.Interface.t()) :: Stripe.Customer.t() | nil
  defp get_stripe_customer(user = %User{}, stripe) do
    case user.stripe_customer_id do
      id when not is_nil(id) -> stripe.get_customer!(id)
      nil -> nil
    end
  end

  # Create a new stripe customer using the Stripe API and record it in the
  # database.
  # Errors if the user already has a stripe customer id.
  @spec create_stripe_customer(User.t(), Stripe.Interface.t()) :: StripeCustomer.t()
  defp create_stripe_customer(%User{stripe_customer_id: nil} = user, stripe) do
    customer = stripe.create_customer!(user)

    user
    |> Ecto.Changeset.change(stripe_customer_id: customer.stripe_id)
    |> Kalda.Repo.update!()

    customer
  end

  @spec send_subscription_created_email(User.t()) :: :ok
  def send_subscription_created_email(user) do
    user
    |> BillingNotifier.subscription_created_email()
    |> Kalda.Mailer.deliver_now()

    :ok
  end

  ## Database getters

  @doc """
  Gets subscription events by user id.

  ## Examples

      iex> get_subscription_event_by_user_id(user_id)
      [%SubscriptionEvent{}, %SubscriptionEvent{} ...]

      iex> get_subscription_event_by_user_id(user_id, [limit: 2])
      [%SubscriptionEvent{}, %SubscriptionEvent{}]

      iex> get_subscription_event_by_user(user_id)
      []

  """
  def get_subscription_events_by_user_id(user_id, opts \\ []) do
    limit = opts[:limit] || 100

    from(event in SubscriptionEvent,
      where: event.user_id == ^user_id,
      limit: ^limit,
      order_by: [desc: event.inserted_at]
    )
    |> Repo.all()
  end

  ## Setters

  @doc """
  Creates a subscription_event for a user, given an event of ENUM type.

  ## Examples

      iex> create_subscription_event(user, :subscription_created, %{field: value})
      {:ok, %SubscriptionEvent{}}

      iex> create_subscription_event(user, event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription_event(user, event, attrs \\ %{}) do
    %SubscriptionEvent{user_id: user.id, event: event}
    |> SubscriptionEvent.changeset(attrs)
    |> Repo.insert()
  end
end
