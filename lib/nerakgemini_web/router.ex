defmodule NerakgeminiWeb.Router do
  use NerakgeminiWeb, :router

  # Pipelines
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NerakgeminiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Backpex.ThemeSelectorPlug # Backpex Admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Scopes
  scope "/", NerakgeminiWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Backpex Admin
  import Backpex.Router
  scope "/admin", NerakgeminiWeb.Admin do
    pipe_through :browser

    backpex_routes()

    get "/", RedirectController, :redirect_to_posts

    live_session :default, on_mount: Backpex.InitAssigns do
      live_resources "/posts", PostLive
      live_resources "/images", ImageLive
    end

  end

  # JSON API v1
  scope "/api/v1", NerakgeminiWeb.API.V1 do
    pipe_through :api

    resources "/posts", PostController, only: [:index, :show]
    resources "/images", ImageController, only: [:index, :show]
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:nerakgemini, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NerakgeminiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
