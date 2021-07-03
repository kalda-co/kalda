defmodule Kalda.Payments do
  @moduledoc """
  The Payments context.
  """

  alias Kalda.Payments.StripeCustomer
  alias Kalda.Accounts.User
  alias Stripe, as: StripeLibrary

  @doc """
  Create a new stripe customer using the Stripe API and insert it into our database.
  """
  @spec create_stripe_customer(User.t()) ::
          {:ok, StripeCustomer.t()} | {:error, StripeLibrary.Error.t()}
  def create_stripe_customer(user = %User{}) do
    with {:ok, customer} <- StripeLibrary.Customer.create(%{email: user.email}) do
      {:ok, insert_stripe_customer!(user, customer)}
    end
  end

  @spec insert_stripe_customer!(User.t(), StripeLibrary.Customer.t()) :: StripeCustomer.t()
  defp insert_stripe_customer!(user = %User{}, customer = %Stripe.Customer{}) do
    %StripeCustomer{user: user, stripe_id: customer.id}
    |> StripeCustomer.changeset(%{})
    |> Kalda.Repo.insert!()
  end
end
