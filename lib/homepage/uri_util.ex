defmodule Homepage.UriUtil do
  def clean_fragment(url) do
    URI.new!(url)
    |> put_in([Access.key!(:fragment)], "")
    |> URI.to_string()
    |> String.trim_trailing("#")
  end
end
