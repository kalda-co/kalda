defmodule Kalda.Repo.Migrations.ReportsRemoveForeignKeys do
  use Ecto.Migration

  def up do
    drop constraint(:reports, :reports_post_id_fkey)
    drop constraint(:reports, :reports_reply_id_fkey)
    drop constraint(:reports, :reports_comment_id_fkey)
  end

  def down do
    alter table(:reports) do
      modify :post_id, references(:posts, on_delete: :nothing)
      modify :comment_id, references(:comments, on_delete: :nothing)
      modify :reply_id, references(:replies, on_delete: :nothing)
    end
  end
end
