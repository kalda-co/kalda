defmodule Kalda.Forums.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :sent, :boolean, default: false, null: false
    field :read, :boolean, default: false, null: false
    field :expired, :boolean, default: false, null: false

    belongs_to :user, Kalda.Accounts.User,
      foreign_key: :user_id,
      references: :id

    belongs_to :post, Kalda.Forums.Post,
      foreign_key: :post_id,
      references: :id

    belongs_to :comment, Kalda.Forums.Comment,
      foreign_key: :comment_id,
      references: :id

    # belongs_to :reply, Kalda.Forums.Reply,
    #   foreign_key: :reply_id,
    #   references: :id

    # belongs_to :notification_author, Kalda.Accounts.User,
    #   foreign_key: :notification_author_id,
    #   references: :id

    # belongs_to :notification_post, Kalda.Forums.Post,
    #   foreign_key: :notification_post_id,
    #   references: :id

    belongs_to :notification_comment, Kalda.Forums.Comment,
      foreign_key: :notification_comment_id,
      references: :id

    belongs_to :notification_reply, Kalda.Forums.Reply,
      foreign_key: :notification_reply_id,
      references: :id

    # belongs_to :notification_reply_reaction, Kalda.Forums.ReplyReaction,
    #   foreign_key: :notification_reply_reaction_id,
    #   references: :reply_reactions_pkey

    # belongs_to :notification_comment_reaction, Kalda.Forums.CommentReaction,
    #   foreign_key: :notification_comment_reaction_id,
    #   references: :comment_id, :author_id

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [
      :sent,
      :read,
      :expired,
      # :notification_author,
      # :notification_post_id,
      :notification_comment_id,
      :notificaion_reply_id
      # :notification_reply_reaction_id,
      # :notification_comment_reaction_id
    ])
    |> validate_required([:user_id])
  end
end
