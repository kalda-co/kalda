defmodule KaldaWeb.Api.V1.PostView do
  use KaldaWeb, :view

  def render("index.json", params) do
    %{
      data: Enum.map(params.posts, &render_post/1)
    }
  end

  def render("show.json", params) do
    %{
      data: render_post(params.post)
    }
  end

  defp render_post(post) do
    %{
      id: post.id,
      author: render_author(post.author),
      content: post.content,
      comments: Enum.map(post.comments, &render_comment/1),
      inserted_at: post.inserted_at
    }
  end

  defp render_author(author) do
    %{
      id: author.id,
      name: "TODO change me to have a name"
    }
  end

  defp render_comment(comment) do
    %{
      id: comment.id,
      author: render_author(comment.author),
      content: comment.content,
      inserted_at: comment.inserted_at
    }
  end
end
