defmodule MonsterWeb.Router do
  use MonsterWeb, :router

  @ratelimit_max_requests 5
  @ratelimit_decay_period 1_000

  pipeline :api do
    plug :accepts, ["json"]
    plug Hammer.Plug, rate_limit: {"api:ratelimit", @ratelimit_decay_period, @ratelimit_max_requests}, by: :ip
  end

  pipeline :auth_required do
    plug MonsterWeb.Plugs.TokenAuthPlug
  end

  scope "/api", MonsterWeb do
    pipe_through :api

    scope "/auth" do
      post "/register", AuthController, :register
      post "/login", AuthController, :login
    end

    scope "/revoke_token" do
      pipe_through :auth_required
      post "/", AuthController, :revoke_token
    end

    scope "/character" do
      pipe_through :auth_required

      get "/", CharacterController, :index
      get "/:id", CharacterController, :get

      post "/", CharacterController, :create
      patch "/:id", CharacterController, :update

      delete "/:id", CharacterController, :delete
    end
  end

  scope "/", MonsterWeb do
    pipe_through :api
    get "/", DefaultController, :index
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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MonsterWeb.Telemetry
    end
  end
end
