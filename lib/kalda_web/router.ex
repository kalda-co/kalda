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
    plug :fetch_session
    plug :protect_from_forgery
    plug :fetch_current_user
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
    get "/users/log-in", UserSessionController, :new
    post "/users/log-in", UserSessionController, :create
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

    get "/app", PageController, :app
  end

  scope "/admin", KaldaWeb.Admin, as: :admin do
    pipe_through [:browser, :require_admin]

    get "/users", UserController, :index
    get "/posts", PostController, :index
    get "/posts/new", PostController, :new
    post "/posts", PostController, :create
    get "/posts/:id", PostController, :show
    get "/posts/:id/edit", PostController, :edit
    put "/posts/:id", PostController, :update
    delete "/posts/:id", PostController, :delete
  end

  scope "/", KaldaWeb do
    pipe_through [:basic_auth_prod, :browser]

    delete "/users/log-out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/v1", KaldaWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :json_require_authenticated_user]

    get "/posts", PostController, :index
  end
end
