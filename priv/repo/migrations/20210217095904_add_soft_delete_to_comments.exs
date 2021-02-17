defmodule Kalda.Repo.Migrations.AddSoftDeleteToComments do
  use Ecto.Migration

  def change do

    execute(
      """
      DO $$
      BEGIN
        PERFORM prepare_table_for_soft_delete('comments');
        PERFORM prepare_table_for_soft_delete('posts');
        PERFORM prepare_table_for_soft_delete('replies');
        PERFORM prepare_table_for_soft_delete('users');
      END $$
      """,
      """
      DO $$
      BEGIN
        PERFORM reverse_table_soft_delete('comments');
        PERFORM reverse_table_soft_delete('posts');
        PERFORM reverse_table_soft_delete('replies');
        PERFORM reverse_table_soft_delete('users');
      END $$
      """
    )

  end
end
