defmodule Homepage.Hackernews do
  def to_hn(url) do
    url = Homepage.UriUtil.clean_fragment(url)

    {base, query} =
      case Req.get!("https://hn.algolia.com/api/v1/search", params: [tags: "story", query: url]) do
        # Redirect to submit page
        %{body: %{"nbHits" => 0}} ->
          title = get_page_title(url)
          query = [{"u", url}, {"t", title}]

          base = %{
            host: "news.ycombinator.com",
            path: "/submitlink"
          }

          {base, query}

        # Redirect directly to discussion
        %{body: %{"nbHits" => 1, "hits" => [%{"story_id" => id}]}} ->
          query = [{"id", id}]

          base = %{
            host: "news.ycombinator.com",
            path: "/item"
          }

          {base, query}

        # Redirect to search page
        _ ->
          query = [{"q", url}]

          base = %{
            host: "hn.algolia.com"
          }

          {base, query}
      end

    param = URI.encode_query(query, :rfc3986)

    %URI{
      scheme: "https",
      port: 443,
      query: param
    }
    |> struct(base)
    |> URI.to_string()
  end

  defp get_page_title(url) do
    %{status: 200, body: body} = Req.get!(url)

    Floki.parse_document!(body)
    |> Floki.find("head")
    |> Floki.find("title")
    |> Floki.text()
    |> String.trim()
  end
end
