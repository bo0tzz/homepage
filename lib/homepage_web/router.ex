defmodule HomepageWeb.Router do
  use HomepageWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HomepageWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomepageWeb do
    pipe_through :browser

    get "/", HomePageController, :index
    get "/to-hn", HackernewsController, :index
    get "/bugzilla-rss", BugzillaRssController, :index


    get "/posts", PostsController, :index
    get "/posts/:id", PostsController, :show
  end

  scope "/.well-known", HomepageWeb do
    pipe_through :api

    get "/immich", HomePageController, :immich_well_known
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomepageWeb do
  #   pipe_through :api
  # end
end
