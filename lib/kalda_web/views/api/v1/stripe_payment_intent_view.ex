defmodule KaldaWeb.Api.V1.StripePaymentIntentView do
  use KaldaWeb, :view

  def render("show.json", %{client_secret: client_secret}) do
    %{
      client_secret: client_secret
    }
  end
end
