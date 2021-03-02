defmodule Kalda.Repo.Migrations.ReportsAddModeratorActionEnum do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE moderator_action AS ENUM (
      'delete',
      'do_nothing'
    )
    """

    alter table(:reports) do
      remove :moderator_action
      add :moderator_action, :moderator_action
    end
  end

  def down do
    execute("DROP TYPE moderator_action")

    alter table(:reports) do
      remove :moderator_action
      add :moderator_action, :string
    end
  end
end
