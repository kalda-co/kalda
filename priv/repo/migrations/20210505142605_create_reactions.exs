defmodule Kalda.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:comment_reactions, primary_key: false) do
      add :send_love, :boolean, default: false, null: false
      add :relate, :boolean, default: false, null: false
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false, primary_key: true
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true, null: false, primary_key: true

      timestamps()
    end

    # create unique_index(:comment_reactions, [:comment_id, :author_id], name: :comment_reactions_pkey)
    # create index(:comment_reactions, [:comment_id, :author_id])
  end
end
