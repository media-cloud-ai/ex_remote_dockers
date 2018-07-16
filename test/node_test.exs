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

  test "get version" do
    containers = Node.version!(@node_config)
    assert false
  end
end
