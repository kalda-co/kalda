defmodule Kalda.Repo.Migrations.PostsAddAuthorIdColumn do
  use Ecto.Migration

  def change do

    alter table(:posts) do
      add :author_id, references(:users, on_delete: :delete_all), foreign_key: true, null: false
    end

    create index(:posts, [:author_id])
  end
end
