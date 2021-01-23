defmodule KaldaWeb.LayoutView do
  use KaldaWeb, :view

  # For more info on optimising meta tags see
  # https://css-tricks.com/essential-meta-tags-social-media/

  defp title_text(conn) do
    title = conn.assigns[:page_title]

    if title do
      title <> " - Kalda"
    else
      "Kalda"
    end
  end

  defp description_text(conn) do
    description = conn.assigns[:page_description]

    if description do
      description
    else
      "Daily reflection, weekly connection. Helping the LGBTQIA plus and sex positive community to build support networks, access group therapy and get better, together"
    end
  end
end
