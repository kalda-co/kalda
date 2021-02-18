defmodule Kalda.Accounts.Invite do
  use Ecto.Schema
  import Ecto.Changeset

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

  # def verify_token_for_email(token, invitee_email) do
  #   query =
  #     from(i in token_query(token, invitee_email),
  #       where: i.token.inserted_at > ago(@token_validity_in_days, "day"),
  #       select: i
  #     )

  #   {:ok, query}
  # end

  # def token_query(token, invitee_email) do
  #   from Kalda.Accounts.Invite, where: [token: ^token, invitee_email: ^invitee_email]
  # end

  # def verify_session_token_query(token) do
  #   query =
  #     from token in token_and_context_query(token, "session"),
  #       join: user in assoc(token, :user),
  #       where: token.inserted_at > ago(@session_validity_in_days, "day"),
  #       select: user

  #   {:ok, query}
  # end
end
