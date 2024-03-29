defmodule Kalda.Events.TherapySession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "therapy_sessions" do
    field :starts_at, :naive_datetime
    field :link, :string
    field :title, :string, default: "Group Therapy"
    field :description, :string, default: "Description TBC"
    field :therapist, :string, default: "TBC"
    field :credentials, :string, default: "Kalda guided meditation coach"

    timestamps()
  end

  @doc false
  def changeset(therapy_session, attrs) do
    therapy_session
    |> cast(attrs, [:starts_at, :link, :title, :description, :therapist, :credentials])
    |> validate_length(:credentials, max: 5000)
    |> validate_length(:description, max: 5000)
    |> validate_required([:starts_at, :link])
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
