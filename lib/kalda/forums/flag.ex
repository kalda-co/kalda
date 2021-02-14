defmodule Kalda.Forums.Flag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flags" do
    field :flagged_content, :string
    field :reporter_reason, :string
    field :moderator_action, :string
    field :moderator_reason, :string

    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id

    belongs_to :reporter, Kalda.Accounts.User,
      foreign_key: :reporter_id,
      references: :id

    belongs_to :moderator, Kalda.Accounts.User,
      foreign_key: :moderator_id,
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

    field :resolved_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [:reporter_reason])
    |> validate_required([:reporter_id, :reporter_reason, :flagged_content, :author_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:comment_id)
    |> foreign_key_constraint(:reply_id)
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:reporter_id)
    |> foreign_key_constraint(:moderator_id)
  end
end
