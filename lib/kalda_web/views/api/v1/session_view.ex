defmodule KaldaWeb.Api.V1.SessionView do
  use KaldaWeb, :view

  def render("show.json", %{token: token}) do
    %{
      token: token
    }
  end

  def render("invalid.json", _) do
    %{
      errors: %{email: ["invalid email or password"]}
    }
  end
end
