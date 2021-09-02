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

    # The post by the OP recieving the notification
    # One of post or comment only per notification
    belongs_to :post, Kalda.Forums.Post,
      foreign_key: :post_id,
      references: :id

    # The comment by the OP recieving the notification
    # One of post or comment only per notification
    belongs_to :comment, Kalda.Forums.Comment,
      foreign_key: :comment_id,
      references: :id

    # The notification_comment cannot be accessed through the post because there may be multiple comments per post
    # One of notification_reply OR notification_comment per notification
    # If a user makes a post which someone comments on, this is the comment that creates the notification
    # Only exists if post exists on notification
    belongs_to :notification_comment, Kalda.Forums.Comment,
      foreign_key: :notification_comment_id,
      references: :id

    # The notification_reply cannot be accessed through the comment because there may be multiple replies per comment
    # One of notification_reply OR notification_comment per notification
    # If a user makes a comment which someone replies to, this is the reply that creates the notification
    # Only exists if comment exists on notification (not post)
    belongs_to :notification_reply, Kalda.Forums.Reply,
      foreign_key: :notification_reply_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [
      :sent,
      :read,
      :expired,
      :notification_comment_id,
      :notification_reply_id
    ])
    |> validate_required([:user_id])
  end
end
