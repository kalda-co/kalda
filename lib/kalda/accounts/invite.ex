defmodule Kalda.Accounts.Invite do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @rand_size 32
  @token_validity_in_days 5

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
  Generates a token
  tokens in future could be hashed.
  """
  # TODO: hash token sent in email
  def build_token(invitee_email) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %Kalda.Accounts.Invite{token: token, invitee_email: invitee_email}}
  end

  def verify_token_for_email(token, email) do
    query =
      from i in Kalda.Accounts.Invite,
        where: i.token == ^token,
        where: i.invitee_email == ^email,
        where: i.inserted_at > ago(@token_validity_in_days, "day"),
        select: i

    {:ok, query}
  end
end
