defmodule Kalda.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags) do
      add :post_id, references(:posts, on_delete: :nothing), foreign_key: true
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true
      add :reply_id, references(:replies, on_delete: :nothing), foreign_key: true
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false
      add :flagged_content, :string, null: false

      add :reporter_id, references(:users, on_delete: :nothing), foreign_key: true, null: false
      add :reporter_reason, :string, null: false

      add :moderator_id, references(:users, on_delete: :nothing), foreign_key: true
      add :moderator_action, :string
      add :moderator_reason, :string

      add :resolved_at, :naive_datetime

      # add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:flags, [:post_id])
    create index(:flags, [:comment_id])
    create index(:flags, [:reply_id])
    create index(:flags, [:reporter_id])
    create index(:flags, [:author_id])
    create index(:flags, [:moderator_id])
  end
end
