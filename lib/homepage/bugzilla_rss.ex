defmodule Homepage.BugzillaRss do
  def feed_url(bug_url) do
    url = Homepage.UriUtil.clean_fragment(bug_url)

    %URI{
      scheme: "https",
      host: "bo0tzz.me",
      path: "/bugzilla-rss",
      query: URI.encode_query(%{url: url})
    }
    |> URI.to_string()
  end

  def build_feed(bug_url) do
    %URI{host: host, query: query} = uri = URI.new!(bug_url)
    %{"id" => id} = URI.decode_query(query)

    bug = get_bug(host, id)
    comments = get_comments(host, id)

    {:ok, last_change, _} = DateTime.from_iso8601(bug["last_change_time"])

    map_comment = fn comment ->
      comment_url = %URI{uri | fragment: "c#{comment["count"]}"} |> URI.to_string()
      {:ok, comment_time, _} = DateTime.from_iso8601(comment["creation_time"])

      Atomex.Entry.new(comment_url, comment_time, "New comment by #{comment["author"]}")
      |> Atomex.Entry.author(comment["author"])
      |> Atomex.Entry.content(comment["text"])
      |> Atomex.Entry.build()
    end

    Atomex.Feed.new(bug_url, last_change, bug["summary"])
    |> Atomex.Feed.author(bug["creator_detail"]["real_name"],
      email: bug["creator_detail"]["email"]
    )
    |> Atomex.Feed.link(feed_url(bug_url), rel: "self")
    |> Atomex.Feed.link(bug_url, rel: "via")
    |> Atomex.Feed.entries(Enum.map(comments, map_comment))
    |> Atomex.Feed.build()
    |> Atomex.generate_document()
  end

  def get_bug(host, id) do
    %{"bugs" => [bug]} = get(host, ["rest", "bug", id])

    bug
  end

  def get_comments(host, id) do
    body = get(host, ["rest", "bug", id, "comment"])
    body["bugs"][id]["comments"]
  end

  defp get(host, path) do
    path = "/" <> Enum.join(path, "/")

    %{status: 200, body: body} =
      %URI{
        scheme: "https",
        host: host,
        path: path
      }
      |> URI.to_string()
      |> Req.get!()

    body
  end
end
