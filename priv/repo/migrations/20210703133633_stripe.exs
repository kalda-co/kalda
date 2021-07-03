defmodule Kalda.Repo.Migrations.Stripe do
  use Ecto.Migration

  def change do
    create table(:stripe_customers) do
      add :stripe_id, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), foreign_key: true, null: false
      timestamps()
    end

    create table(:stripe_subscriptions) do
      add :stripe_id, :string, null: false

      add :stripe_customer_id, references(:stripe_customers, on_delete: :delete_all),
        foreign_key: true,
        null: false

      timestamps()
    end

    create index(:stripe_customers, [:user_id], unique: true)
    create index(:stripe_subscriptions, [:stripe_customer_id], unique: true)
  end
end
