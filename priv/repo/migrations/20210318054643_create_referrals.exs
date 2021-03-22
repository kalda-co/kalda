defmodule Kalda.Repo.Migrations.CreateReferralLinks do
  use Ecto.Migration

  def change do

    create table(:referral_links) do
      add :name, :string, null: false
      add :expires_at, :naive_datetime, null: false
      add :referring_slots, :integer, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    alter table(:users) do
      add :referred_by, references(:referral_links, on_delete: :nilify_all)
    end

  end
end
