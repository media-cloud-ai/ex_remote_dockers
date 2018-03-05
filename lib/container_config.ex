defmodule RemoteDockers.ContainerConfig do
  alias RemoteDockers.MountPoint

  @enforce_keys [:Image]
  defstruct [
    :Image,
    :Env,
    :HostConfig
  ]

  @doc """
  Build a container configuration with a specified `image_name`.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    %ContainerConfig{:Image => "hello-world", :Env => [], :HostConfig => %{}}
    ```
  """
  def new(image_name) do
    %RemoteDockers.ContainerConfig{
      "Image": image_name,
      "Env": [],
      "HostConfig": %{}
    }
  end

  @doc """
  Add an environment variable to the specified container configuration.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.add_env("TOTO", "/path/to/toto")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => ["TOTO=/path/to/toto"],
      :HostConfig => %{}
    }
    ```
  """
  @spec add_env(RemoteDockers.ContainerConfig, bitstring, bitstring) :: RemoteDockers.ContainerConfig
  def add_env(%RemoteDockers.ContainerConfig{} = container_config, key, value) do
    env =
      Map.get(container_config, :Env)
      |> List.insert_at(-1, key <> "=" <> value)
    container_config
    |> Map.put(:Env, env)
  end

  @doc """
  Add a volume mount point description to the container host configuration.

  ## Example:
    ```elixir
    mount_point = %{
      "Source": "/path/to/host/mount/point",
      "Target": "/path/to/container/directory",
      "Type": "bind"
    }
    ContainerConfig.new("MyImage")
    |> ContainerConfig.add(mount_point)
    ```
  """
  @spec add_mount_point(RemoteDockers.ContainerConfig, MountPoint) :: RemoteDockers.ContainerConfig
  def add_mount_point(%RemoteDockers.ContainerConfig{} = container_config, %MountPoint{} = mount_point) do
    host_config = Map.get(container_config, :HostConfig, %{})

    mount_points =
      Map.get(host_config, :Mounts, [])
      |> List.insert_at(-1, mount_point)

    host_config = Map.put(host_config, :Mounts, mount_points)
    container_config
    |> Map.put(:HostConfig, host_config)
  end

  @doc """
  Add a volume mount point binding (i.e. mount type is `bind`) to the container configuration.

  `source` and `target` values are respectively mapped to the `"Source"` and `"Target"` mount point
  description fields.

  See `add_mount_point/2`

  ## Example:
    ```elixir
    iex> ContainerConfig.new("image_name")
    ...> |> ContainerConfig.add_mount_point("/path/to/a/host/mount/point", "/path/to/a/container/directory")
    ...> |> ContainerConfig.add_mount_point("/path/to/another/host/mount/point", "/path/to/another/container/directory")
    %ContainerConfig{
      :Image => "image_name",
      :Env => [],
      :HostConfig => %{
        :Mounts => [
          %MountPoint{
            :Source => "/path/to/a/host/mount/point",
            :Target => "/path/to/a/container/directory",
            :Type => "bind"
          },
          %MountPoint{
            :Source => "/path/to/another/host/mount/point",
            :Target => "/path/to/another/container/directory",
            :Type => "bind"
          }
        ]
      }
    }
    ```
  """
  @spec add_mount_point(RemoteDockers.ContainerConfig, bitstring, bitstring, bitstring) :: RemoteDockers.ContainerConfig
  def add_mount_point(%RemoteDockers.ContainerConfig{} = container_config, source, target, type \\ "bind") do
    add_mount_point(container_config, MountPoint.new(source, target, type))
  end

end