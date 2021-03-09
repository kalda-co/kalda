defmodule Kalda.Repo.Migrations.ChangeVarcharsToText do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :content, :text, from: :string
    end

    alter table(:comments) do
      modify :content, :text, from: :string
    end

    alter table(:replies) do
      modify :content, :text, from: :string
    end

    alter table(:reports) do
      modify :reported_content, :text, from: :string
      modify :moderator_reason, :text, from: :string
    end

    alter table(:therapy_sessions) do
      modify :description, :text, from: :string
      modify :credentials, :text, from: :string
    end
  end
end
