defmodule Kalda.Events.TherapySession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "therapy_sessions" do
    field :event_datetime, :naive_datetime
    field :link, :string

    timestamps()
  end

  @doc false
  def changeset(therapy_session, attrs) do
    therapy_session
    |> cast(attrs, [:event_datetime, :link])
    |> validate_required([:event_datetime, :link])
  end
end
