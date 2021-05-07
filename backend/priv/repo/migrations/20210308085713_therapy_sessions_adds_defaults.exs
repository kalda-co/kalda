defmodule Kalda.Repo.Migrations.TherapySessionsAddsDefaults do
  use Ecto.Migration

  # TODO: this migration is already in production but there is no way to roll it back.
  def change do
    alter table(:therapy_sessions) do
      modify :title, :string, default: "Group Therapy"
      modify :description, :string, default: "Description TBC"
      modify :therapist, :string, default: "TBC"
      modify :credentials, :string, default: "Kalda guided meditation coach"
    end
  end
end
