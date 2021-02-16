defmodule KaldaWeb.Api.V1.FlagView do
  use KaldaWeb, :view
  alias KaldaWeb.Api.V1.UserView

  def render("show.json", %{flag: flag}) do
    render_flag(flag)
  end

  def render_flag(flag) do
    %{
      id: flag.id,
      reporter_reason: flag.reporter_reason,
      reporter: UserView.render_author(flag.reporter),
      comment_id: flag.comment_id,
      inserted_at: flag.inserted_at
    }
  end
end
