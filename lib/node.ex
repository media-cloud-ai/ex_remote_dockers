defmodule RemoteDockers.Node do
  alias RemoteDockers.Client
  alias RemoteDockers.NodeConfig

  @info_uri "/v1.30/info"

  @doc """
  Get Node version
  """
  @spec version!(NodeConfig.t()) :: string
  def version!(%NodeConfig{} = node_config) do
    response =
      @info_uri
      |> Client.build_uri(node_config)
      |> Client.get!([], NodeConfig.get_options(node_config))

    case response.status_code do
      200 ->
        response.body

      _ ->
        raise "unable to get version of this node"
    end
  end

  def version!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))
end
