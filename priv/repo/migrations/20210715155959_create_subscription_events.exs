defmodule Kalda.Repo.Migrations.CreateSubscriptionEvents do
  use Ecto.Migration

  # def change do
  #   create table(:subscription_events) do
  #     add :user_id, references(:users, on_delete: :delete_all), null: false
  #     add :event_type, :string, null: false

  #     timestamps()
  #   end
  # end
# end

  def change do
    create_query = """
    CREATE TYPE event_type AS ENUM (
      'subscription_created',
      'subscription_deleted'
    )
    """

    drop_query = "DROP TYPE event_type"
    execute(create_query, drop_query)

    create table(:subscription_events) do
      add :event, :event_type, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
