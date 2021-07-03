defmodule Kalda.Payments do
  @moduledoc """
  The Payments context.
  """

  alias Kalda.Payments.StripeCustomer
  alias Kalda.Payments.StripeSubscription
  alias Kalda.Accounts.User
  alias Stripe, as: StripeLibrary
  require Ecto.Query, as: Query

  @doc """
  Get the stripe customer for a user if it exists. Alternatively create a new
  stripe customer using the Stripe API and insert it into our database.
  """
  @spec get_or_create_stripe_customer(User.t()) ::
          {:ok, StripeCustomer.t()} | {:error, StripeLibrary.Error.t()}
  def get_or_create_stripe_customer(user = %User{}) do
    case get_stripe_customer(user) do
      nil -> create_stripe_customer(user)
      customer -> {:ok, customer}
    end
  end

  @spec get_stripe_customer(User.t()) :: StripeCustomer.t() | nil
  defp get_stripe_customer(user = %User{}) do
    Query.from(customer in StripeCustomer, where: customer.user_id == ^user.id)
    |> Kalda.Repo.one()
  end

  @doc """
  Create a new stripe customer using the Stripe API and insert it into our database.
  """
  @spec create_stripe_customer(User.t()) ::
          {:ok, StripeCustomer.t()} | {:error, StripeLibrary.Error.t()}
  def create_stripe_customer(user = %User{}) do
    case StripeLibrary.Customer.create(%{email: user.email}) do
      {:ok, customer} -> {:ok, insert_stripe_customer!(user, customer)}
      {:error, _} = error -> error
    end
  end

  @spec insert_stripe_customer!(User.t(), StripeLibrary.Customer.t()) :: StripeCustomer.t()
  defp insert_stripe_customer!(user = %User{}, customer = %StripeLibrary.Customer{}) do
    %StripeCustomer{user_id: user.id, stripe_id: customer.id}
    |> StripeCustomer.changeset(%{})
    |> Kalda.Repo.insert!()
  end

  @spec insert_stripe_subscription!(StripeCustomer.t(), StripeLibrary.Subscription.t()) ::
          StripeSubscription.t()
  defp insert_stripe_subscription!(
         customer = %StripeCustomer{},
         subscription = %StripeLibrary.Subscription{}
       ) do
    %StripeSubscription{stripe_customer: customer, stripe_id: subscription.id}
    |> StripeSubscription.changeset(%{})
    |> Kalda.Repo.insert!()
  end

  @doc """
  Create a new pending stripe subscription using the Stripe API and insert it
  into our database.
  """
  @spec create_stripe_subscription!(StripeCustomer.t()) :: StripeSubscription.t()
  def create_stripe_subscription!(customer = %StripeCustomer{}) do
    {:ok, subscription} = create_subscription_via_stripe_api(customer)
    insert_stripe_subscription!(customer, subscription)
  end

  @spec create_subscription_via_stripe_api(StripeCustomer.t()) ::
          {:ok, StripeLibrary.Subscription.t()} | {:error, StripeLibrary.Error.t()}
  defp create_subscription_via_stripe_api(customer = %StripeCustomer{}) do
    params = %{
      customer: customer.stripe_id,
      payment_behavior: "default_imcomplete",
      expand: ["latest_invoice.payment_intent"],
      items: []
    }

    import StripeLibrary.Request

    new_request([])
    |> put_endpoint("subscriptions")
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :customer])
    |> make_request()
  end
end
