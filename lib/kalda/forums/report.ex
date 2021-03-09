defmodule Kalda.Forums.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :reported_content, :string
    field :reporter_reason, :string
    field :moderator_action, Ecto.Enum, values: [:delete, :do_nothing]
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
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:reporter_reason])
    |> validate()
  end

  def validate(changeset) do
    changeset
    |> validate_required([:reporter_id, :reporter_reason, :reported_content, :author_id])
    |> validate_length(:reporter_reason, max: 700)
    |> validate_length(:moderator_reason, max: 700)
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:reporter_id)
    |> foreign_key_constraint(:moderator_id)
  end

  def moderation_changeset(report, attrs) do
    fields = [:moderator_action, :resolved_at, :moderator_id, :moderator_reason]

    report
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate()
  end
end
