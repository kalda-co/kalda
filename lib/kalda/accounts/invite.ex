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

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:invitee_email])
    |> validate_required([:invitee_email, :token])
  end

  @doc """
  build_invite(email)
    {url-encoded token, Invite}
  """
  def build_invite(email) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %__MODULE__{
       token: hashed_token,
       invitee_email: email
     }}
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
