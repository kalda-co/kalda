defmodule Kalda.Forums.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string

    field :forum, Ecto.Enum,
      values: [:daily_reflection, :will_pool, :community, :co_working],
      default: :daily_reflection

    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id

    has_many :comments, Kalda.Forums.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content, :author_id])
    |> foreign_key_constraint(:author_id)
  end
end
