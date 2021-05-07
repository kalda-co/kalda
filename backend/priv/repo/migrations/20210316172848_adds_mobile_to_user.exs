defmodule Kalda.Repo.Migrations.AddsMobileToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :mobile, :string
    end

  end
end
