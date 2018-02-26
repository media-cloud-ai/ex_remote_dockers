defmodule ExRemoteDockers.ContainersTest do
  use ExUnit.Case
  doctest ExRemoteDockers.Containers

  test "host from config array" do
    config_hosts = [
      [host: "localhost", port: 2357]
    ]
    hosts =
      Enum.map config_hosts, fn host ->
        %ExRemoteDockers.HostConfig{host: host[:host], port: host[:port]}
      end
    assert length(hosts) == length(config_hosts)
  end

  test "list containers" do
    hosts = [%ExRemoteDockers.HostConfig{}]
    Enum.each hosts, fn host ->
      containers = ExRemoteDockers.Containers.list(host)
      assert is_list(containers.body)
    end
  end

  test "list all containers" do
    hosts = [%ExRemoteDockers.HostConfig{}]
    Enum.each hosts, fn host ->
      containers = ExRemoteDockers.Containers.list_all(host)
      assert is_list(containers.body)
    end
  end

  defp inspect_status(host, container_id, expected_status) do
    response = ExRemoteDockers.Containers.inspect(host, container_id)
    assert response.status_code == 200 # OK
    assert response.body["State"]["Status"] == expected_status
  end

  test "create & remove container" do
    host = %ExRemoteDockers.HostConfig{}

    # Create
    response = ExRemoteDockers.Containers.create(host, "new_container", %{"Image": "hello-world"})
    assert response.status_code == 201 # Created
    container_id = response.body["Id"]
    inspect_status(host, container_id, "created")

    # Start
    response = ExRemoteDockers.Containers.start(host, container_id)
    assert response.status_code == 204 # No Content
    inspect_status(host, container_id, "running")

    # Stop
    response = ExRemoteDockers.Containers.stop(host, container_id)
    assert response.status_code == 204 # No Content
    inspect_status(host, container_id, "exited")

    # Delete
    response =  ExRemoteDockers.Containers.remove(host, container_id)
    assert response.status_code == 204 # No Content
    
    response = ExRemoteDockers.Containers.inspect(host, container_id)
    assert response.status_code == 404 # Not found
  end

end
