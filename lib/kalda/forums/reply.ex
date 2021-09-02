defmodule Kalda.Forums.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :content, :string
    # field :author_id, :id
    # field :comment_id, :id
    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id

    belongs_to :comment, Kalda.Forums.Comment,
      foreign_key: :comment_id,
      references: :id

    has_many :reply_reactions, Kalda.Forums.ReplyReaction

    has_one :notification, Kalda.Forums.Notification,
      foreign_key: :notification_reply_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:content])
    |> validate_required([:content, :author_id, :comment_id])
    |> validate_length(:content, max: 5000)
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:comment_id)
  end
end
