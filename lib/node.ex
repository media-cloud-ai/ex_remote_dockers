defmodule RemoteDockers.Node do
  alias RemoteDockers.Client
  alias RemoteDockers.NodeConfig

  @info_uri "/v1.35/info"

  @doc """
  Get Node info
  """
  @spec info!(NodeConfig.t()) :: map()
  def info!(%NodeConfig{} = node_config) do
    response =
      @info_uri
      |> Client.build_uri(node_config)
      |> Client.get!([], NodeConfig.get_options(node_config))

    case response.status_code do
      200 ->
        response.body

      _ ->
        raise "unable to get info of this node"
    end
  end

  def info!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))
end
