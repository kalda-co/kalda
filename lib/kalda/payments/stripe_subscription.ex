defmodule Kalda.Payments.StripeSubscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kalda.Payments.StripeCustomer

  schema "stripe_subscriptions" do
    field :stripe_id, :string, null: false
    belongs_to :stripe_customer, StripeCustomer, foreign_key: :user_id, references: :id
    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:stripe_id])
    |> validate_required([:stripe_id])
    |> validate_length(:stripe_id, min: 1)
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
