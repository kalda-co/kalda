defmodule Kalda.Repo.Migrations.PostsAddPublishedAt do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published_at, :timestamp, default: fragment("NOW()"), null: false
    end

    create index(:posts, [:published_at])
  end
end
