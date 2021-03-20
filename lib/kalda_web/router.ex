defmodule KaldaWeb.Router do
  use KaldaWeb, :router
  use Plug.ErrorHandler

  import KaldaWeb.UserAuth

  defp handle_errors(conn, data) do
    KaldaWeb.Errors.handle_errors(conn, data)
  end

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
    delete "/users/log-out", UserSessionController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      # TODO: remove
      live "/live-example", PageLive, :index
      forward "/sent-emails", Bamboo.SentEmailViewerPlug
    end
  end

  ## Authentication routes

  scope "/", KaldaWeb do
    pipe_through [:basic_auth_prod, :browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
  end

  scope "/", KaldaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    get "/users/log-in", UserSessionController, :new
    post "/users/log-in", UserSessionController, :create
    get "/users/reset-password", UserResetPasswordController, :new
    post "/users/reset-password", UserResetPasswordController, :create
    get "/users/reset-password/:token", UserResetPasswordController, :edit
    put "/users/reset-password/:token", UserResetPasswordController, :update
    get "/invites/:token", InviteController, :show
    post "/invites", InviteController, :create

    get "/referral-links/:name", ReferralLinkController, :show
    post "/referral-links", ReferralLinkController, :create
  end

  scope "/", KaldaWeb do
    pipe_through [:browser, :require_authenticated_user, :require_confirmed_email]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email

    get "/app", PageController, :app
  end

  scope "/admin", KaldaWeb.Admin, as: :admin do
    import Phoenix.LiveDashboard.Router
    pipe_through [:browser, :require_admin]

    get "/", AdminController, :index

    get "/users", UserController, :index

    resources "/reports", ReportController do
      resources "/comments", CommentController, only: [:delete]
      resources "/replies", ReplyController, only: [:delete]
    end

    resources "/forums/:forum/posts", PostController, only: [:new, :index]

    resources "/posts", PostController, except: [:new, :index] do
      resources "/comments", CommentController, only: [:delete] do
        resources "/replies", ReplyController, only: [:delete]
      end
    end

    live_dashboard "/dashboard", metrics: KaldaWeb.Telemetry
    get "/invites", InviteController, :new
    post "/invites", InviteController, :create

    get "/referral-links", ReferralLinkController, :index
    get "/referral-links/new", ReferralLinkController, :new
    post "/referral-links", ReferralLinkController, :create

    get "/therapy-sessions/new", TherapySessionController, :new
    get "/therapy-sessions", TherapySessionController, :index
    post "/therapy-sessions", TherapySessionController, :create
    get "/therapy-sessions/:id", TherapySessionController, :edit
    put "/therapy-sessions/:id", TherapySessionController, :update
    delete "/therapy-sessions/:id", TherapySessionController, :delete
  end

  scope "/", KaldaWeb do
    pipe_through [:basic_auth_prod, :browser]

    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    get "/crash", CrashController, :index
  end

  scope "/v1", KaldaWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :json_require_authenticated_user, :json_require_confirmed_email]

    get "/dashboard", DashboardController, :index
    get "/ping", PingController, :show

    post "/posts/:id/comments", CommentController, :create
    post "/comments/:id/replies", ReplyController, :create
    post "/comments/:id/reports", ReportController, :report_comment
    post "/replies/:id/reports", ReportController, :report_reply
  end
end
