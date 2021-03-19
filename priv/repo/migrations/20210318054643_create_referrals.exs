defmodule Kalda.Repo.Migrations.CreateReferrals do
  use Ecto.Migration

  def change do

    create table(:referrals) do
      # add :token, :binary, null: false
      add :name, :string, null: false
      add :expires_at, :naive_datetime, null: false
      add :referring_slots, :integer, null: false
      add :referrer_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    alter table(:users) do
      add :referred_by, references(:referrals)
    end

    # alter table(:invites) do
    #   add :referral_id, references(:referrals)
    # end

  end
end
