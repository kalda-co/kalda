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
    |> validate_url(:link)
  end

  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      uri = URI.parse(value)

      [
        if(uri.scheme == nil, do: "is missing a scheme (e.g. https)"),
        if(uri.host == nil, do: "is missing a host (e.g. example.com)")
      ]
      |> Enum.filter(fn error -> error != nil end)
      |> Enum.map(fn error -> {field, Keyword.get(opts, :message, error)} end)
    end)
  end
end
