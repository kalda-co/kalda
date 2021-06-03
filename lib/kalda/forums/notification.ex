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

    belongs_to :reply, Kalda.Forums.Reply,
      foreign_key: :reply_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:sent, :read, :expired])
    |> validate_required([:user_id])
  end
end
