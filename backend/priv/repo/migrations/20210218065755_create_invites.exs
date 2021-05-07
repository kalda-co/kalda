defmodule Kalda.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :invitee_email, :citext, null: false
      add :token, :binary, null: false
      timestamps(updated_at: false)
    end

    create unique_index(:invites, [:token])
  end
end
