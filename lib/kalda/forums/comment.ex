defmodule Kalda.Forums.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    # field :author_id, :id
    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id

    belongs_to :post, Kalda.Forums.Post,
      foreign_key: :post_id,
      references: :id

    has_many :replies, Kalda.Forums.Reply
    has_many :comment_reactions, Kalda.Forums.CommentReaction

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content, :author_id, :post_id])
    |> validate_length(:content, max: 5000)
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:post_id)
  end
end
