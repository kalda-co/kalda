defmodule Kalda.Forums.CommentReaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment_reactions" do
    field :relate, :boolean, default: false
    field :send_love, :boolean, default: false
    field :author_id, :id
    field :comment_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment_reaction, attrs) do
    comment_reaction
    |> cast(attrs, [:send_love, :relate])
    |> validate_required([:send_love, :relate])
  end
end
