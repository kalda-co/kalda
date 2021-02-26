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
      case URI.parse(value) do
        %URI{scheme: nil} ->
          "is missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end
end
