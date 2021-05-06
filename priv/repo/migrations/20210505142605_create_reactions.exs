defmodule Kalda.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:comment_reactions) do
      add :send_love, :boolean, default: false, null: false
      add :relate, :boolean, default: false, null: false
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true, null: false

      timestamps()
    end

    create index(:comment_reactions, [:comment_id, :author_id])
  end
end
