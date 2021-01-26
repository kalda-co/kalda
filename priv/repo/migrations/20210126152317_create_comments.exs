defmodule Kalda.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :author_id, references(:users, on_delete: :nilify_all), foreign_key: true, null: false
      add :post_id, references(:posts, on_delete: :delete_all), foreign_key: true, null: false

      timestamps()
    end

    create index(:comments, [:author_id, :post_id])
  end
end
