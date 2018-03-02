defmodule RemoteDockers.ContainerTest do
  use ExUnit.Case
  alias RemoteDockers.{Container, HostConfig}
  doctest RemoteDockers.Container

  @host_config HostConfig.build(
    Application.get_env(:remote_dockers, :hostname),
    Application.get_env(:remote_dockers, :port),
    Application.get_env(:remote_dockers, :certfile),
    Application.get_env(:remote_dockers, :keyfile)
  )

  test "list containers" do
    containers = Container.list!(@host_config)
    assert is_list(containers)
  end

  test "list all containers" do
    containers = Container.list_all!(@host_config)
    assert is_list(containers)
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
    response = Container.start!(container)
    assert response.id == container.id
    inspect_status(container, "running")

    # Stop
    response = Container.stop!(container)
    assert response.id == container.id
    inspect_status(container, "exited")

    # Delete
    response = Container.remove!(container)
    assert response == :ok

    assert_raise(RuntimeError, "unable to retrieve container", fn -> Container.get_status!(container) end)
  end

end
