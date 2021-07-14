defmodule Kalda.Repo.Migrations.AddHasStripeSubscriptionToUsres do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :has_stripe_subscription, :boolean, null: false, default: false
    end
  end
end
