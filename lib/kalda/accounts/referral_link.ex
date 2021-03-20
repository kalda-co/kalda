defmodule Kalda.Accounts.ReferralLink do
  use Ecto.Schema
  import Ecto.Changeset

  # @rand_size 32
  # @hash_algorithm :sha256

  schema "referral_links" do
    # field :token, :binary
    field :name, :string

    field :expires_at, :naive_datetime,
      default: NaiveDateTime.add(NaiveDateTime.local_now(), 1_209_600),
      null: false

    field :referring_slots, :integer, null: false, default: 6

    belongs_to :referrer, Kalda.Accounts.User,
      foreign_key: :owner_id,
      references: :id

    timestamps()
  end

  def changeset(referral_link, attrs) do
    referral_link
    |> cast(attrs, [:name, :owner_id, :expires_at, :referring_slots])
    |> validate_required([:owner_id, :name])
    |> foreign_key_constraint(:owner_id)
    |> validate_format(:name, ~r/\A[a-z0-9-]+\z/,
      message: "can only use lowercase letters, numbers and hyphens"
    )
    |> unsafe_validate_unique(:name, Kalda.Repo)
    |> unique_constraint(:name)
  end

  def empty_changeset() do
    %__MODULE__{} |> cast(%{}, [])
  end

  # when called
  # def build_referral(referrer, attrs \\ %{}) do
  #   %{token: token, hashed_token: hashed_token} = build_token()

  #   attrs =
  #     attrs
  #     |> Enum.into(%{
  #       owner_id: referrer.id,
  #       token: hashed_token
  #     })

  #   changeset =
  #     %__MODULE__{}
  #     |> cast(attrs, [:token, :referrer, :expires_at, :referring_slots])
  #     |> validate_required([:referrer, :token])

  #   %{token: token, changeset: changeset}
  # end

  # def empty_changeset() do
  #   %__MODULE__{} |> cast(%{}, [])
  # end

  # defp build_token() do
  #   token = :crypto.strong_rand_bytes(@rand_size)
  #   hashed_token = :crypto.hash(@hash_algorithm, token)
  #   %{token: Base.url_encode64(token, padding: false), hashed_token: hashed_token}
  # end

  # def hash_token(token) do
  #   case Base.url_decode64(token, padding: false) do
  #     {:ok, decoded_token} ->
  #       {:ok, :crypto.hash(@hash_algorithm, decoded_token)}

  #     :error ->
  #       :error
  #   end
  # end
end
