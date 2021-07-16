defmodule Kalda.Payments.SubscriptionEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          name: event_name(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @type event_name() :: :stripe_subscription_created | :stripe_subscription_deleted

  schema "subscription_events" do
    field :name, Ecto.Enum, values: [:stripe_subscription_created, :stripe_subscription_deleted]

    belongs_to :user, Kalda.Accounts.User,
      foreign_key: :user_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(subscription_event, attrs) do
    subscription_event
    |> cast(attrs, [:name])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
