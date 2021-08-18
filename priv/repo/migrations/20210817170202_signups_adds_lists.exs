defmodule Kalda.Repo.Migrations.SignupsAddsLists do
  use Ecto.Migration

  def change do
    alter table(:signups) do

      add :list, :string, default: "waitlist_56109"
    end
  end
end
