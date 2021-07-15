defmodule Kalda.Payments.SubscriptionEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscription_events" do
    # field :event_type, :string
    field :event, Ecto.Enum, values: [:subscription_created, :subscription_deleted]

    belongs_to :user, Kalda.Accounts.User,
      foreign_key: :user_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(subscription_event, attrs) do
    subscription_event
    |> cast(attrs, [:event])
    |> validate_required([:event, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
