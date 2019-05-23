defmodule RemoteDockers.Client do
  use HTTPoison.Base

  @moduledoc """
  Documentation for `ExRemoteDockers.Client`
  """

  def process_request_headers(headers) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
  end

  def process_request_options(options) do
    options
    |> Keyword.put(:timeout, 60000)
    |> Keyword.put(:recv_timeout, 60000)
  end

  def process_response_body(""), do: nil

  def process_response_body(body) do
    try do
      body
      |> Jason.decode!()
    rescue
      _ ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(fn line -> Jason.decode!(line) end)
    end
  end

  def build_endpoint(endpoint, action \\ "/json")
  def build_endpoint(endpoint, "/" <> _action = action), do: endpoint <> action
  def build_endpoint(endpoint, action), do: endpoint <> "/" <> action

  def build_uri(endpoint, node_config) do
    node_config.hostname <> ":" <> force_string(node_config.port) <> endpoint
  end

  def force_string(value) when is_integer(value), do: Integer.to_string(value)
  def force_string(value), do: value
end
