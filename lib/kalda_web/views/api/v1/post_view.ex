defmodule KaldaWeb.Api.V1.PostView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView
  alias KaldaWeb.Api.V1.CommentView

  def render("show.json", %{post: post}) do
    render_post(post)
  end

  defp render_post(post) do
    %{
      id: post.id,
      author: UserView.render_author(post.author),
      content: post.content,
      comments: Enum.map(post.comments, &CommentView.render_comment/1),
      published_at: post.published_at,
      forum: post.forum
    }
  end
end
