defmodule RemoteDockers.Container do
  alias RemoteDockers.{Client, HostConfig}
  @moduledoc """
  Connector to manage containers
  """

  @enforce_keys [:container_id, :host_config]
  defstruct [:container_id, :host_config]

  @containers_uri "/containers"

  @doc """
  List running containers
  """
  def list!(host_config) do
    Client.build_endpoint(@containers_uri)
    |> Client.build_uri(host_config)
    |> Client.get!([], HostConfig.get_options(host_config))
  end

  @doc """
  List all containers
  """
  def list_all!(host_config) do
    options =
      HostConfig.get_options(host_config)
      |> Keyword.put(:query, %{"all" => true})

    Client.build_endpoint(@containers_uri)
    |> Client.build_uri(host_config)
    |> Client.get!([], options)
  end

  @doc """
  Create a container
  """
  def create!(host_config, name, image) do
    options =
      HostConfig.get_options(host_config)
      |> Keyword.put(:name, name)

    response =
      Client.build_endpoint(@containers_uri, "create")
      |> Client.build_uri(host_config)
      |> Client.post!(%{"Image": image} |> Poison.encode!, [], options)

    case response.status_code do
      201 -> %RemoteDockers.Container{
          container_id: response.body["Id"],
          host_config: host_config
        }
      _ -> raise "unable to create image"
    end
  end

  @doc """
  Remove a container
  """
  def remove!(container) do
    response =
      Client.build_endpoint(@containers_uri, container.container_id)
      |> Client.build_uri(container.host_config)
      |> Client.delete!()

    case response.status_code do
      204 -> :ok
      _ -> raise "unable to delete container"
    end
  end

  @doc """
  Start a container
  """
  def start!(container) do
    response =
      Client.build_endpoint(@containers_uri, container.container_id <> "/start")
      |> Client.build_uri(container.host_config)
      |> Client.post!("", [], HostConfig.get_options(container.host_config))

    case response.status_code do
      204 -> container
      _ -> raise "unable to start container"
    end
  end

  @doc """
  Stop a container
  """
  def stop!(container) do
    response =
      Client.build_endpoint(@containers_uri, container.container_id <> "/stop")
      |> Client.build_uri(container.host_config)
      |> Client.post!("", [], HostConfig.get_options(container.host_config))

    case response.status_code do
      204 -> container
      _ -> raise "unable to stop container"
    end
  end

  @doc """
  Get status of a container
  """
  def get_status!(%RemoteDockers.Container{} = container) do
    response =
      Client.build_endpoint(@containers_uri, container.container_id <> "/json")
      |> Client.build_uri(container.host_config)
      |> Client.get!()

    case response.status_code do
      200 -> response.body["State"]["Status"]
      _ -> raise "unable to retrieve container"
    end
  end
end
