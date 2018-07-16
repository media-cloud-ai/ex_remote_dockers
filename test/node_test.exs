defmodule RemoteDockers.NodeTest do
  use ExUnit.Case

  alias RemoteDockers.{
    Node,
    NodeConfig
  }

  doctest RemoteDockers.Container

  @node_config NodeConfig.new(
                 Application.get_env(:remote_dockers, :hostname),
                 Application.get_env(:remote_dockers, :port),
                 Application.get_env(:remote_dockers, :certfile),
                 Application.get_env(:remote_dockers, :keyfile)
               )

  test "get info" do
    info = Node.info!(@node_config)
    assert is_map(info)
  end
end
