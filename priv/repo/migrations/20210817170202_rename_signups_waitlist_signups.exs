defmodule Kalda.Repo.Migrations.RenameSignupsWaitlistSignups do
  use Ecto.Migration

  def up do

    rename table(:signups), to: table(:waitlist_signups)

    execute "ALTER INDEX signups_email_index RENAME TO waitlist_signups_email_index"
  end

  def down do

    rename table(:waitlist_signups), to: table(:signups)

    execute "ALTER INDEX waitlist_signups_email_index RENAME TO signups_email_index"

  end
end
