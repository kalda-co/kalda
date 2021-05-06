defmodule Kalda.Forums.CommentReaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "comment_reactions" do
    field :relate, :boolean, default: false, null: false
    field :send_love, :boolean, default: false, null: false

    belongs_to :comment, Kalda.Forums.Comment,
      foreign_key: :comment_id,
      references: :id,
      primary_key: true

    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id,
      primary_key: true

    timestamps()
  end

  @doc false
  def changeset(comment_reaction, attrs) do
    comment_reaction
    |> cast(attrs, [:send_love, :relate])
    |> validate_required([:send_love, :relate])
    |> unique_constraint(:comment_author, name: :comment_reactions_pkey)
  end
end
