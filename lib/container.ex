defmodule RemoteDockers.Container do
  alias RemoteDockers.{
    Client,
    NodeConfig,
    ContainerConfig
  }

  @moduledoc """
  Connector to manage containers
  """

  @enforce_keys [:node_config, :id]
  defstruct [
    :node_config,
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
  @spec list!(NodeConfig.t()) :: list(RemoteDockers.Container)
  def list!(%NodeConfig{} = node_config) do
    response =
      Client.build_endpoint(@containers_uri)
      |> Client.build_uri(node_config)
      |> Client.get!([], NodeConfig.get_options(node_config))

    case response.status_code do
      200 ->
        Enum.map(response.body, fn container ->
          to_container(container, node_config)
        end)

      _ ->
        raise "unable to list containers"
    end
  end

  def list!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  List all containers
  """
  @spec list_all!(NodeConfig.t()) :: list(RemoteDockers.Container)
  def list_all!(%NodeConfig{} = node_config) do
    options =
      NodeConfig.get_options(node_config)
      |> Keyword.put(:params, %{"all" => true})

    response =
      Client.build_endpoint(@containers_uri)
      |> Client.build_uri(node_config)
      |> Client.get!([], options)

    case response.status_code do
      200 ->
        Enum.map(response.body, fn container ->
          to_container(container, node_config)
        end)

      _ ->
        raise "unable to list all containers"
    end
  end

  def list_all!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  Create a container from the specified container's image configuration, or a simple image name.

  ## Examples:
  ```elixir
  container_config =
    ContainerConfig.new("MyImage")
    |> ContainerConfig.add_env("MY_ENV_VAR", "my_env_var_value")
  Container.create!(NodeConfig.new(), "my_container", container_config)
  ```

  ```elixir
  Container.create!(NodeConfig.new(), "my_container", "MyImage")
  ```
  """
  @spec create!(NodeConfig.t(), bitstring, ContainerConfig.t()) :: RemoteDockers.Container
  def create!(%NodeConfig{} = node_config, name, %ContainerConfig{} = container_config) do
    options = NodeConfig.get_options(node_config)

    response =
      Client.build_endpoint(@containers_uri, "create?name=" <> name)
      |> Client.build_uri(node_config)
      |> Client.post!(container_config |> Jason.encode!(), [], options)

    case response.status_code do
      201 ->
        %RemoteDockers.Container{
          id: response.body["Id"],
          node_config: node_config
        }

      _ ->
        raise "unable to create image: " <> response.body["message"]
    end
  end

  @spec create!(NodeConfig.t(), bitstring, bitstring) :: RemoteDockers.Container
  def create!(%NodeConfig{} = node_config, name, image_name) do
    create!(node_config, name, ContainerConfig.new(image_name))
  end

  def create!(_, _, _), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  Remove a container
  """
  @spec remove!(RemoteDockers.Container) :: atom
  def remove!(%RemoteDockers.Container{} = container) do
    response =
      Client.build_endpoint(@containers_uri, container.id)
      |> Client.build_uri(container.node_config)
      |> Client.delete!()

    case response.status_code do
      204 -> :ok
      _ -> raise "unable to delete container: " <> container.id
    end
  end

  def remove!(_), do: raise(ArgumentError.exception("Invalid container type"))

  @doc """
  Start a container
  """
  @spec start!(RemoteDockers.Container) :: RemoteDockers.Container
  def start!(%RemoteDockers.Container{} = container) do
    response =
      Client.build_endpoint(@containers_uri, container.id <> "/start")
      |> Client.build_uri(container.node_config)
      |> Client.post!("", [], NodeConfig.get_options(container.node_config))

    case response.status_code do
      204 -> container
      _ -> raise "unable to start container: " <> container.id
    end
  end

  def start!(_), do: raise(ArgumentError.exception("Invalid container type"))

  @doc """
  Stop a container
  """
  @spec stop!(RemoteDockers.Container) :: RemoteDockers.Container
  def stop!(%RemoteDockers.Container{} = container) do
    response =
      Client.build_endpoint(@containers_uri, container.id <> "/stop")
      |> Client.build_uri(container.node_config)
      |> Client.post!("", [], NodeConfig.get_options(container.node_config))

    case response.status_code do
      204 -> container
      _ -> raise "unable to stop container: " <> container.id
    end
  end

  def stop!(_), do: raise(ArgumentError.exception("Invalid container type"))

  @doc """
  Get status of a container
  """
  @spec get_status!(RemoteDockers.Container) :: bitstring
  def get_status!(%RemoteDockers.Container{} = container) do
    response =
      Client.build_endpoint(@containers_uri, container.id <> "/json")
      |> Client.build_uri(container.node_config)
      |> Client.get!()

    case response.status_code do
      200 -> response.body["State"]["Status"]
      _ -> raise "unable to retrieve container: " <> container.id
    end
  end

  def get_status!(_), do: raise(ArgumentError.exception("Invalid container type"))

  defp to_container(%{} = container, %NodeConfig{} = node_config) do
    %RemoteDockers.Container{
      node_config: node_config,
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
