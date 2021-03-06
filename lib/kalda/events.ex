defmodule Kalda.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Kalda.Repo

  alias Kalda.Events.TherapySession

  @doc """
  Returns all upcoming (future) therapy_sessions.

  ## Examples

      iex> get_therapy_sessions()
      [%TherapySession{}, ...]

  """
  def get_therapy_sessions do
    now = NaiveDateTime.local_now()

    Repo.all(
      from sesh in TherapySession,
        where: sesh.starts_at >= ^now,
        order_by: [asc: sesh.starts_at]
    )
  end

  @doc """
  Gets the next, upcoming therapy_session.

  Raises `Ecto.NoResultsError` if the Therapy session does not exist.

  ## Examples

      iex> get_next_therapy_session!()
      %TherapySession{}

      iex> get_next_therapy_session!()
      ** (Ecto.NoResultsError)

  """
  def get_next_therapy_session!() do
    now = NaiveDateTime.local_now()

    Repo.one(
      from sesh in TherapySession,
        where: sesh.starts_at >= ^now,
        order_by: [asc: sesh.starts_at],
        limit: 1
    )
  end

  @doc """
  Gets a single therapy_session.

  Raises `Ecto.NoResultsError` if the Therapy session does not exist.

  ## Examples

      iex> get_therapy_session!(123)
      %TherapySession{}

      iex> get_therapy_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_therapy_session!(id), do: Repo.get!(TherapySession, id)

  @doc """
  Creates a therapy_session.

  ## Examples

      iex> create_therapy_session(%{field: value})
      {:ok, %TherapySession{}}

      iex> create_therapy_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_therapy_session(attrs \\ %{}) do
    %TherapySession{}
    |> TherapySession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a therapy_session.

  ## Examples

      iex> update_therapy_session(therapy_session, %{field: new_value})
      {:ok, %TherapySession{}}

      iex> update_therapy_session(therapy_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_therapy_session(%TherapySession{} = therapy_session, attrs) do
    therapy_session
    |> TherapySession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a therapy_session.

  ## Examples

      iex> delete_therapy_session(therapy_session)
      {:ok, %TherapySession{}}

      iex> delete_therapy_session(therapy_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_therapy_session(%TherapySession{} = therapy_session) do
    Repo.delete(therapy_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking therapy_session changes.

  ## Examples

      iex> change_therapy_session(therapy_session)
      %Ecto.Changeset{data: %TherapySession{}}

  """
  def change_therapy_session(%TherapySession{} = therapy_session, attrs \\ %{}) do
    TherapySession.changeset(therapy_session, attrs)
  end
end
