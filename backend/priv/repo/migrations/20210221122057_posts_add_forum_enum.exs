defmodule Kalda.Repo.Migrations.PostsAddForumEnum do
  use Ecto.Migration

  def change do
    create_query = """
    CREATE TYPE forum_type AS ENUM (
      'daily_reflection',
      'will_pool',
      'community',
      'co_working'
    )
    """

    drop_query = "DROP TYPE forum_type"
    execute(create_query, drop_query)

    alter table(:posts) do
      add :forum, :forum_type, default: "daily_reflection", null: false
    end

    create index(:posts, [:forum, :inserted_at])
  end
end
