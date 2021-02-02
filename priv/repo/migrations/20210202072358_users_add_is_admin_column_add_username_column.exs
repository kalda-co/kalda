defmodule Kalda.Repo.Migrations.UsersAddIsAdminColumnAddUsernameColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
        add :is_admin, :boolean, null: false, default: false
        add :username, :string, null: false
    end
  end
end
