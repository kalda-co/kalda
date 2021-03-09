defmodule Kalda.Repo.Migrations.ModifiesTherapySessionsDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:therapy_sessions) do
      modify :description, :text, from: :string
      modify :credentials, :text, from: :string
    end

  end
end
