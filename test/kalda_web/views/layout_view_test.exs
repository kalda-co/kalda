defmodule KaldaWeb.LayoutViewTest do
  use KaldaWeb.ConnCase, async: true

  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  # import Phoenix.HTML

  test "blog_page?" do
    conn = %{
      host: "localhost",
      method: "GET",
      params: %{"id" => "do-i-have-to-be-lgbtqia"},
      path_info: ["blog", "do-i-have-to-be-lgbtqia"],
      path_params: %{"id" => "do-i-have-to-be-lgbtqia"},
      port: 4000,
      private: %{
        KaldaWeb.Router => {[], %{}},
        :phoenix_action => :show,
        :phoenix_controller => KaldaWeb.BlogController
      }
    }

    assert KaldaWeb.LayoutView.blog_page?(conn) == true
  end
end
