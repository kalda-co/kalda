defmodule Kalda.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :sent, :boolean, default: false, null: false
      add :read, :boolean, default: false, null: false
      add :expired, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), foreign_key: true, null: false
      add :post_id, references(:posts, on_delete: :nothing), foreign_key: true
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true
      # add :reply_id, references(:replies, on_delete: :nothing), foreign_key: true
      # add :notification_author_id, references(:users, on_delete: :delete_all), foreign_key: true
      # add :notification_post_id, references(:posts, on_delete: :nothing), foreign_key: true
      add :notification_comment_id, references(:comments, on_delete: :nothing), foreign_key: true
      add :notification_reply_id, references(:replies, on_delete: :nothing), foreign_key: true
      # add :notification_comment_reaction_id, references(:comment_reactions, on_delete: :nothing), foreign_key: true
      # add :notification_reply_reaction_id, references(:reply_reactions, on_delete: :nothing), foreign_key: true

      timestamps()
    end

  end
end
