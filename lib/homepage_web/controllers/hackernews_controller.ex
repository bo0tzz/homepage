defmodule HomepageWeb.HackernewsController do
  use HomepageWeb, :controller

  def index(conn, %{"url" => url}) do
    redirect = Homepage.Hackernews.to_hn(url)

    redirect(conn, external: redirect)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
