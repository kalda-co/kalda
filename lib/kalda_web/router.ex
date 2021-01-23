defmodule KaldaWeb.Router do
  use KaldaWeb, :router

  import KaldaWeb.UserAuth

  defp basic_auth(conn, _opts) do
    case Application.get_env(:kalda, :basic_auth_password) do
      nil -> conn
      password -> Plug.BasicAuth.basic_auth(conn, username: "kalda", password: password)
    end
  end

  pipeline :browser do
    # plug :basic_auth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KaldaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth_prod do
    plug :basic_auth
  end

  scope "/", KaldaWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/blog/:id", BlogController, :show
    get "/thanks", PageController, :thanks
    get "/privacy-policy", PageController, :privacy_policy
    get "/terms", PageController, :terms

    post "/signups/new", SignupController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", KaldaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live "/live-example", PageLive, :index
      live_dashboard "/dashboard", metrics: KaldaWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", KaldaWeb do
    pipe_through [:basic_auth_prod, :browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", KaldaWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    # forums
    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit

    # This must require an admin!
    # get "/signups/all", SignupController, :all
  end

  scope "/", KaldaWeb do
    pipe_through [:basic_auth_prod, :browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
