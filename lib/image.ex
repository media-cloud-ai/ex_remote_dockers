defmodule RemoteDockers.Image do
  alias RemoteDockers.{Client, HostConfig}
  @moduledoc """
  Connector to manage images
  """

  @images_uri "/images"

  @doc """
  Returns a list of images
  """
  def list!(host_config) do
    Client.build_endpoint(@images_uri)
    |> Client.build_uri(host_config)
    |> Client.get!([], HostConfig.get_options(host_config))
  end
end
