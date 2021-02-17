defmodule Kalda.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :content, :string
      add :author_id, references(:users, on_delete: :nilify_all), foreign_key: true, null: false

      add :comment_id, references(:comments, on_delete: :delete_all),
        foreign_key: true,
        null: false

      timestamps()
    end

    create index(:replies, [:author_id])
    create index(:replies, [:comment_id])
  end
end
