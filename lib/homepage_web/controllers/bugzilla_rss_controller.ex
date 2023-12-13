defmodule HomepageWeb.BugzillaRssController do
  use HomepageWeb, :controller

  def index(conn, %{"url" => url}) do
    xml = Homepage.BugzillaRss.build_feed(url)

    conn
    |> put_resp_content_type("application/atom+xml")
    |> send_resp(200, xml)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
