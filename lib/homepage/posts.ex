defmodule Homepage.Posts do
  alias Homepage.Posts.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:homepage, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def all_posts, do: @posts
  def published_posts, do: Enum.reject(all_posts(), & &1.draft)
  def recent_posts, do: Enum.take(published_posts(), 3)

  defmodule NotFoundError, do: defexception [:message, plug_status: 404]

  def get_post_by_id!(id) do
    Enum.find(all_posts(), &(&1.id == id)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end
end
