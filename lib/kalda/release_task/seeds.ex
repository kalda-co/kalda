defmodule Kalda.ReleaseTask.Seeds do
  alias Kalda.Accounts.User
  require Ecto.Query, as: Query

  def insert! do
    # Ensure it is safe to run seeds
    query = Query.from(u in User, limit: 1, select: count("id"))
    count = Kalda.Repo.one!(query)

    if count > 0 do
      raise """
      Attempted to run the seeds on a non-empty database!
      Crashing in case this is accidentally being run against production.
      """
    end

    # Insert the seeds
    Code.eval_file("#{:code.priv_dir(:kalda)}/repo/seeds.exs")
  end
end
