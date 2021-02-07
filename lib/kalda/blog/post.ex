defmodule Kalda.Blog.Post do
  @enforce_keys [:id, :author, :title, :subtitle, :body, :description, :tags, :date, :image]
  defstruct [:id, :author, :title, :subtitle, :body, :description, :tags, :date, :image]

  def build(filename, attrs, body) do
    id = filename |> Path.rootname() |> Path.split() |> List.last()
    date = Date.from_iso8601!(attrs.date)

    struct!(
      __MODULE__,
      Map.to_list(attrs) ++ [id: id, date: date, body: body]
    )
  end
end
