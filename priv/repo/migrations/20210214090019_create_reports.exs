defmodule Kalda.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :post_id, references(:posts, on_delete: :nothing), foreign_key: true
      add :comment_id, references(:comments, on_delete: :nothing), foreign_key: true
      add :reply_id, references(:replies, on_delete: :nothing), foreign_key: true
      add :author_id, references(:users, on_delete: :nothing), foreign_key: true, null: false
      add :reported_content, :string, null: false

      add :reporter_id, references(:users, on_delete: :nothing), foreign_key: true, null: false
      add :reporter_reason, :string, null: false

      add :moderator_id, references(:users, on_delete: :nothing), foreign_key: true
      add :moderator_action, :string
      add :moderator_reason, :string

      add :resolved_at, :naive_datetime

      timestamps()
    end

    create index(:reports, [:resolved_at])
  end
end
