defmodule Kalda.Repo.Migrations.CreateTherapySessions do
  use Ecto.Migration

  def change do
    create table(:therapy_sessions) do
      add :event_datetime, :naive_datetime, null: false
      add :link, :string, null: false

      timestamps()
    end

    create index(:therapy_sessions, [:event_datetime])
  end
end
