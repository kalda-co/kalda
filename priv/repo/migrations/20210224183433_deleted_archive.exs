defmodule Kalda.Repo.Migrations.DeletedArchive do
  use Ecto.Migration

  def change do
    # Create table in which to store a copy of deleted records
    create table(:archive) do
      add :table, :string, null: false
      add :data, :jsonb, null: false
      add :deleted_at, :naive_datetime, null: false, default: fragment("NOW()")
    end

    # Create a function that stores a copy of a deleted record
    create_function = """
    create or replace function record_copy_in_archive()
    returns trigger as $body$
    begin
      if (TG_OP != 'DELETE') then
        raise 'record_copy_in_archive is only to be used for deletions';
      end if;
      insert into archive ("table", "data")
      values (TG_TABLE_NAME::regclass::text, to_jsonb(OLD));
      return OLD;
    end;
    $body$
    language plpgsql;
    """

    drop_function = """
    drop function record_copy_in_archive;
    """

    execute(create_function, drop_function)

    # Add the trigger to tables
    apply_trigger("posts")
    apply_trigger("comments")
    apply_trigger("replies")
  end

  def apply_trigger(table) do
    create = """
    create trigger archive_on_delete_trigger
    after delete on #{table}
    for each row execute function record_copy_in_archive();
    """

    drop = """
    drop trigger if exists archive_on_delete_trigger on #{table};
    """

    execute(create, drop)
  end
end
