defmodule HomepageWeb.HomePageController do
  use HomepageWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def immich_well_known(conn, _params) do
    json(conn, %{api: %{endpoint: "https://photos.bo0tzz.me/api"}})
  end
end
