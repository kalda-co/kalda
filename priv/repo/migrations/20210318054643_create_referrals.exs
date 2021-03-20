defmodule Kalda.Repo.Migrations.CreateReferralLinks do
  use Ecto.Migration

  def change do

    create table(:referral_links) do
      # add :token, :binary, null: false
      add :name, :string, null: false
      add :expires_at, :naive_datetime, null: false
      add :referring_slots, :integer, null: false
      add :owner_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    alter table(:users) do
      add :referred_by, references(:referral_links)
    end

    # alter table(:invites) do
    #   add :referral_link_id, references(:referral_links)
    # end

  end
end
