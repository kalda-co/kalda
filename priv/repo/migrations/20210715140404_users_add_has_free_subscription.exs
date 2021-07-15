defmodule Kalda.Repo.Migrations.UsersAddHasSubscription do
  use Ecto.Migration

  def up do

    alter table(:users) do
      add :has_free_subscription, :boolean, null: false, default: false
    end

    # execute(fn -> repo().update_all("users", set: [has_free_subscription: true]) end)

    execute """
    UPDATE users
      SET has_free_subscription = true;
    """

  end

  def down do

    alter table(:users) do
      remove :has_free_subscription
    end
  end
end
