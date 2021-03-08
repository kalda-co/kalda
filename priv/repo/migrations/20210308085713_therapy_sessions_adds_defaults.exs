defmodule Kalda.Repo.Migrations.TherapySessionsAddsDefaults do
  use Ecto.Migration

  def change do
    alter table(:therapy_sessions) do
      modify :title, :string, default: "Group Therapy"
      modify :description, :string, default: "Description TBC"
      modify :therapist, :string, default: "TBC"
      modify :credentials, :string, default: "Kalda guided meditation coach"
    end

  end
end
