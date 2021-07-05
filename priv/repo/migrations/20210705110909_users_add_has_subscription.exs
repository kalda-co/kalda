defmodule Kalda.Repo.Migrations.UsersAddHasSubscription do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :has_stripe_subscription, :boolean, null: false, default: false
      add :has_free_subscription, :boolean, null: false, default: false

      # Do we need this for when the webhook says unpaid...
      # add :subscription_expires_at, :naive_datetime
    end
  end
end
