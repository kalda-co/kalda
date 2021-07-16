defmodule Kalda.Repo.Migrations.CreateSubscriptionEvents do
  use Ecto.Migration

  def change do
    create_query = """
    CREATE TYPE event_name AS ENUM (
      'stripe_subscription_created',
      'stripe_subscription_deleted'
    )
    """

    drop_query = "DROP TYPE event_name"
    execute(create_query, drop_query)

    create table(:subscription_events) do
      add :name, :event_name, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
