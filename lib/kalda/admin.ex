defmodule Kalda.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo
  alias Kalda.Admin.{Archived}

  def list_archived() do
    Repo.all(Archived)
  end
end
