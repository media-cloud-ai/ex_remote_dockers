defmodule RemoteDockers.Container do
  alias RemoteDockers.{Client, HostConfig}
  @moduledoc """
  Connector to manage containers
  """

  @enforce_keys [:host_config, :id]
  defstruct [
    :host_config,
    :id,
    :command,
    :created,
    :image,
    :image_id,
    :labels,
    :mounts,
    :names,
    :ports,
    :state,
    :status
  ]

  @containers_uri "/containers"

  @doc """
  List running containers
  """
  def list!(host_config) do
    response =
      Client.build_endpoint(@containers_uri)
      |> Client.build_uri(host_config)
      |> Client.get!([], HostConfig.get_options(host_config))

    case response.status_code do
      200 -> Enum.map(response.body, fn(container) -> to_container(container, host_config) end)
      _ -> raise "unable to list containers"
    end
  end

  @doc """
  List all containers
  """
  def list_all!(host_config) do
    options =
      HostConfig.get_options(host_config)
      |> Keyword.put(:query, %{"all" => true})

    response =
      Client.build_endpoint(@containers_uri)
      |> Client.build_uri(host_config)
      |> Client.get!([], options)

    case response.status_code do
      200 -> Enum.map(response.body, fn(container) -> to_container(container, host_config) end)
      _ -> raise "unable to list all containers"
    end
  end

  @doc """
  Create a container
  """
  def create!(host_config, name, image) do
    options =
      HostConfig.get_options(host_config)

    response =
      Client.build_endpoint(@containers_uri, "create?name=" <> name)
      |> Client.build_uri(host_config)
      |> Client.post!(%{"Image": image} |> Poison.encode!, [], options)

    case response.status_code do
      201 -> %RemoteDockers.Container{
          id: response.body["Id"],
          host_config: host_config
        }
      _ -> raise "unable to create image: " <> response.body["message"]
    end
  end

  @doc """
  Remove a container
  """
  def remove!(container) do
    response =
      Client.build_endpoint(@containers_uri, container.id)
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
      Client.build_endpoint(@containers_uri, container.id <> "/start")
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
      Client.build_endpoint(@containers_uri, container.id <> "/stop")
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
      Client.build_endpoint(@containers_uri, container.id <> "/json")
      |> Client.build_uri(container.host_config)
      |> Client.get!()

    case response.status_code do
      200 -> response.body["State"]["Status"]
      _ -> raise "unable to retrieve container"
    end
  end

  defp to_container(%{} = container, %HostConfig{} = host_config) do
    %RemoteDockers.Container{
      host_config: host_config,
      id: container["Id"],
      command: container["Command"],
      created: container["Created"],
      image: container["Image"],
      image_id: container["ImageID"],
      labels: container["Labels"],
      mounts: container["Mounts"],
      names: container["Names"],
      ports: container["Ports"],
      state: container["State"],
      status: container["Status"]
    }
  end
end
