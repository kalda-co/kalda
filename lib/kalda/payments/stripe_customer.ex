defmodule Kalda.Payments.StripeCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stripe_customers" do
    field :stripe_id, :string, null: false
    belongs_to :user, Kalda.Accounts.User, foreign_key: :user_id, references: :id
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
