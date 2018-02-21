defmodule ExRemoteDockers.ContainersTest do
  use ExUnit.Case
  doctest ExRemoteDockers.Containers

  test "list containers" do
    hosts = Application.get_env(:ex_remote_dockers, :hosts)
    Enum.each hosts, fn host ->
      assert ExRemoteDockers.Containers.list(host) != ""
    end
  end

  test "list all containers" do
    hosts = Application.get_env(:ex_remote_dockers, :hosts)
    Enum.each hosts, fn host ->
      assert ExRemoteDockers.Containers.list_all(host) != ""
    end
  end

  defp inspect_status(host, container_id, expected_status) do
    response = ExRemoteDockers.Containers.inspect(host, container_id)
    assert response.status_code == 200 # OK
    assert response.body["State"]["Status"] == expected_status
  end

  test "create & remove container" do
    host = List.first(Application.get_env(:ex_remote_dockers, :hosts))

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
