defmodule HomepageWeb.PostsController do
  use HomepageWeb, :controller

  alias Homepage.Posts

  def index(conn, _params) do
    render(conn, "index.html", posts: Posts.published_posts())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", post: Posts.get_post_by_id!(id))
  end
end
