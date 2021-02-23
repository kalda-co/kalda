defmodule Kalda.Repo.Migrations.PostsAddPublishedAt do
  use Ecto.Migration

  def change do
  # execute("ALTER TABLE posts ADD published_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP")
    alter table(:posts) do
      add :published_at, :timestamp, default: fragment("NOW()"), null: false
    end

    create index(:posts, [:published_at])
  end
end
