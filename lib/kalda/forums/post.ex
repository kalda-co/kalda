defmodule Kalda.Forums.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string

    field :forum, Ecto.Enum, values: [:daily_reflection, :will_pool, :community, :co_working]

    belongs_to :author, Kalda.Accounts.User,
      foreign_key: :author_id,
      references: :id

    has_many :comments, Kalda.Forums.Comment

    field :published_at, :naive_datetime, default: NaiveDateTime.local_now(), null: false

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :published_at, :forum])
    |> validate_required([:content, :author_id, :forum])
    |> validate_length(:content, max: 5000)
    |> foreign_key_constraint(:author_id)
  end
end
