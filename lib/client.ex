defmodule ExRemoteDockers.Client do
  use HTTPotion.Base
  @moduledoc """
  Documentation for ExRemoteDockers.Client.
  """

  def process_url(url, options) do
    url
    |> prepend_protocol
    |> append_query_string(options)
  end

  defp prepend_protocol(url) do
    if url =~ ~r/\Ahttps?:\/\// do
      url
    else
      "http://" <> url
    end
  end

  defp append_query_string(url, options) do
    if options[:query] do
      url <> "?#{URI.encode_query(options[:query])}"
    else
      url
    end
  end

  def process_request_headers(headers) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
  end

  def process_response_body(body) when length(body) > 0 do
    body
    |> Poison.decode!
  end

  def process_response_body(body) do
    body
  end
end
