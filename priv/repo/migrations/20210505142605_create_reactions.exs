defmodule Kalda.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:comment_reactions, primary_key: false) do
      add :send_love, :boolean, default: false, null: false
      add :relate, :boolean, default: false, null: false
      # Order is important, because of the composite primary key
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true, null: false, primary_key: true
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false, primary_key: true

      timestamps()
    end

  end
end
