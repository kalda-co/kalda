defmodule Kalda.Admin.Archived do
  @moduledoc """
  Records that have been deleted. You do not need to ever write to this table
  manually, it is autoamtically written to using a trigger. See
  priv/repo/migrations/20210224183433_deleted_archive.exs for details.
  """
  use Ecto.Schema

  schema "archive" do
    field :table, :string
    field :data, :map
    field :deleted_at, :naive_datetime
  end
end
