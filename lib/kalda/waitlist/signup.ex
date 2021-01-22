defmodule Kalda.Waitlist.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "signups" do
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(signup, attrs) do
    signup
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 254)
    |> unsafe_validate_unique(:email, Kalda.Repo)
    |> unique_constraint(:email)
  end
end
