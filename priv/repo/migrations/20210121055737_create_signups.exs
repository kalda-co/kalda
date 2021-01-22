defmodule Kalda.Repo.Migrations.CreateSignups do
  use Ecto.Migration

  def change do

    create table(:signups) do
      add :email, :citext

      timestamps()
    end
    create index(:signups, [:email], unique: true)

  end
end
