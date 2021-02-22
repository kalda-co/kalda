defmodule Kalda.Accounts.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  @rand_size 32
  @hash_algorithm :sha256

  schema "invites" do
    field :invitee_email, :string
    field :token, :binary

    timestamps(updated_at: false)
  end

  def build_invite(email) do
    %{token: token, hashed_token: hashed_token} = build_token()
    attrs = %{invitee_email: email, token: hashed_token}

    changeset =
      %__MODULE__{}
      |> cast(attrs, [:token, :invitee_email])
      |> validate_required([:invitee_email, :token])
      |> validate_format(:invitee_email, ~r/^[^\s]+@[^\s]+$/,
        message: "must have the @ sign and no spaces"
      )
      |> validate_length(:invitee_email, max: 254)

    %{token: token, changeset: changeset}
  end

  def empty_changeset() do
    %__MODULE__{} |> cast(%{}, [])
  end

  @doc """
  build_invite(email)
    {url-encoded token, Invite}
  """
  defp build_token() do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)
    %{token: Base.url_encode64(token, padding: false), hashed_token: hashed_token}
  end

  def hash_token(token) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        {:ok, :crypto.hash(@hash_algorithm, decoded_token)}

      :error ->
        :error
    end
  end
end
