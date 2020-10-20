defmodule RemoteDockers.LogClient do
  use HTTPoison.Base

  @moduledoc """
  HTTP client for reading docker logs
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

  def process_response_body(""), do: []

  # the format for the body is described at
  # https://docs.docker.com/engine/api/v1.35/#operation/ContainerAttach
  def process_response_body(
        <<stream_type, 0, 0, 0, length::size(32), data::binary-size(length), rest::binary>>
      ) do
    type =
      case stream_type do
        0 -> :stdin
        1 -> :stdout
        2 -> :stderr
      end

    [{type, data} | process_response_body(rest)]
  end

  def build_endpoint(endpoint, action \\ "/logs")
  def build_endpoint(endpoint, "/" <> _action = action), do: endpoint <> action
  def build_endpoint(endpoint, action), do: endpoint <> "/" <> action

  def build_uri(endpoint, node_config) do
    node_config.hostname <> ":" <> force_string(node_config.port) <> endpoint
  end

  def force_string(value) when is_integer(value), do: Integer.to_string(value)
  def force_string(value), do: value
end
