defmodule Kalda.Repo.Migrations.Stripe do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_customer_id, :string, null: true
    end
  end
end
