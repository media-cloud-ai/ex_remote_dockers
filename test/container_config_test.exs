defmodule RemoteDockers.ContainerConfigTest do
  use ExUnit.Case

  alias RemoteDockers.{
    Container,
    ContainerConfig,
    NodeConfig,
    MountPoint
  }

  doctest RemoteDockers.ContainerConfig

  @node_config NodeConfig.new(
                 Application.get_env(:remote_dockers, :hostname),
                 Application.get_env(:remote_dockers, :port),
                 Application.get_env(:remote_dockers, :certfile),
                 Application.get_env(:remote_dockers, :keyfile)
               )

  test "set user" do
    container_config =
      ContainerConfig.new("alpine:latest")
      |> ContainerConfig.set_user("nobody")
      |> ContainerConfig.set_command("whoami")

    container = Container.create!(@node_config, container_config)

    Container.start!(container)

    logs = Container.get_logs!(container)

    assert logs == [stdout: "nobody\n"]

    Container.stop!(container)

    Container.remove!(container)
  end
end
