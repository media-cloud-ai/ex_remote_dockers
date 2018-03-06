defmodule RemoteDockers.ContainerTest do
  use ExUnit.Case
  alias RemoteDockers.{
      Container,
      DockerHostConfig,
      ContainerConfig
    }
  doctest RemoteDockers.Container

  @host_config DockerHostConfig.new(
    Application.get_env(:remote_dockers, :hostname),
    Application.get_env(:remote_dockers, :port),
    Application.get_env(:remote_dockers, :certfile),
    Application.get_env(:remote_dockers, :keyfile)
  )

  test "list containers" do
    containers = Container.list!(@host_config)
    assert is_list(containers)
  end

  test "fail listing containers" do
    assert_raise(ArgumentError, "Invalid host config type", fn -> Container.list!("host_config") end)
  end

  test "list all containers" do
    containers = Container.list_all!(@host_config)
    assert is_list(containers)
  end

  test "fail listing all containers" do
    assert_raise(ArgumentError, "Invalid host config type", fn -> Container.list_all!("host_config") end)
  end

  defp inspect_status(container, expected_status) do
    status = Container.get_status!(container)
    assert status == expected_status
  end

  test "create & remove container" do
    # Create
    container = Container.create!(@host_config, "new_container", "rabbitmq:management")
    inspect_status(container, "created")

    # Delete
    response = Container.remove!(container)
    assert response == :ok

    assert_raise(RuntimeError, "unable to retrieve container: " <> container.id, fn -> Container.get_status!(container) end)
  end

  test "create & remove container with configuration" do
    # Create
    container_config =
      ContainerConfig.new("rabbitmq:management")
      |> ContainerConfig.add_env("RABBITMQ_DEFAULT_VHOST", "/")
      |> ContainerConfig.add_mount_point("/tmp", "/opt/rabbitmq")
    container = Container.create!(@host_config, "new_container", container_config)
    inspect_status(container, "created")

    # Delete
    response = Container.remove!(container)
    assert response == :ok

    assert_raise(RuntimeError, "unable to retrieve container: " <> container.id, fn -> Container.get_status!(container) end)
  end

  test "create, start, stop & remove container" do
    # Create
    container = Container.create!(@host_config, "new_container", ContainerConfig.new("rabbitmq:management"))
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

    assert_raise(RuntimeError, "unable to retrieve container: " <> container.id, fn -> Container.get_status!(container) end)
  end

end
