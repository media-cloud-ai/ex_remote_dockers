defmodule RemoteDockers.ContainerTest do
  use ExUnit.Case
  alias RemoteDockers.{Container, HostConfig}
  doctest RemoteDockers.Container

  @host_config HostConfig.build(
    "https://192.168.99.100",
    "/path/to/cert.pem",
    "/path/to/key.pem"
  )

  test "list containers" do
    containers = Container.list!(@host_config)
    assert is_list(containers.body)
  end

  test "list all containers" do
    containers = Container.list_all!(@host_config)
    assert is_list(containers.body)
  end

  defp inspect_status(container, expected_status) do
    status = Container.get_status!(container)
    assert status == expected_status
  end

  test "create & remove container" do
    # Create
    container = Container.create!(@host_config, "new_container", "rabbitmq:management")
    inspect_status(container, "created")

    # Start
    Container.start!(container)
    inspect_status(container, "running")

    # Stop
    Container.stop!(container)
    inspect_status(container, "exited")

    # Delete
    Container.remove!(container)

    assert_raise(RuntimeError, "unable to retrieve container", fn -> Container.get_status!(container) end)
  end

end
