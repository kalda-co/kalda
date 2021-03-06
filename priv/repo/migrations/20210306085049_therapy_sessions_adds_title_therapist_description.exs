defmodule Kalda.Repo.Migrations.TherapySessionsAddsTitleTherapistDescription do
  use Ecto.Migration

  def change do
    alter table(:therapy_sessions) do
      add :title, :string
      add :description, :string
      add :therapist, :string
      add :credentials, :string
    end

    rename table(:therapy_sessions), :event_datetime, to: :starts_at
  end
end
