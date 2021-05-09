defmodule Kalda.Forums.ReplyReaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "reply_reactions" do
    field :relate, :boolean, default: false, null: false
    field :send_love, :boolean, default: false, null: false

    belongs_to :reply, Kalda.Forums.Reply,
      foreign_key: :reply_id,
      references: :id,
      primary_key: true

    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id,
      primary_key: true

    timestamps()
  end

  @doc false
  def changeset(reply_reaction, attrs) do
    reply_reaction
    |> cast(attrs, [:send_love, :relate])
    |> validate_required([:send_love, :relate])
    |> unique_constraint(:reply_author, name: :reply_reactions_pkey)
  end
end
