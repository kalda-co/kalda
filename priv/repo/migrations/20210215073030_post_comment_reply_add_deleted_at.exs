defmodule Kalda.Repo.Migrations.PostCommentReplyAddDeletedAt do
  use Ecto.Migration

  def change do

    alter table(:posts) do
      add :deleted_at, :naive_datetime
    end

    alter table(:comments) do
      add :deleted_at, :naive_datetime
    end

    alter table(:replies) do
      add :deleted_at, :naive_datetime
    end

  end
end
