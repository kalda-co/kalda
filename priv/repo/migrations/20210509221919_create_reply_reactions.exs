defmodule Kalda.Repo.Migrations.CreateReplyReactions do
  use Ecto.Migration

  def change do
    create table(:reply_reactions, primary_key: false) do
      add :send_love, :boolean, default: false, null: false
      add :relate, :boolean, default: false, null: false
      # Order is important, because of the composite primary key
      add :reply_id, references(:replies, on_delete: :nothing), foreign_key: true, null: false, primary_key: true
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false, primary_key: true

      timestamps()
    end

  end
end
