defmodule Kalda.Repo.Migrations.CreatePosts do
  use Ecto.Migration

    def change do
      create table(:posts) do
        add :content, :string
        add :author_id, references(:users, on_delete: :delete_all), foreign_key: true, null: false

        timestamps()
    end

    create index(:posts, [:author_id])
  end
end
