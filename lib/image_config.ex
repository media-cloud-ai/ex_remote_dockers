defmodule RemoteDockers.ImageConfig do
  @enforce_keys [:Image]
  defstruct [
    :Image,
    :Env,
    :HostConfig
  ]

  @doc """
  Build an image configuration with a specified `image_name`.
  """
  def new(image_name) do
    %RemoteDockers.ImageConfig{
      "Image": image_name,
      "Env": [],
      "HostConfig": %{
        "Mounts": []
      }
    }
  end

  @doc """
  Add an environment variable to the specified image configuration.
  """
  @spec add_env(RemoteDockers.ImageConfig, bitstring, bitstring) :: RemoteDockers.ImageConfig
  def add_env(%RemoteDockers.ImageConfig{} = image_config, key, value) do
    env =
      Map.get(image_config, :Env)
      |> List.insert_at(-1, key <> "=" <> value)
    image_config
    |> Map.put(:Env, env)
  end

  @doc """
  Add a volume mount point description to the image host configuration.

  ## Example:
    ```elixir
    mount_point = %{
      "Source": "/path/to/host/mount/point",
      "Target": "/path/to/container/directory",
      "Type": "bind"
    }
    ImageConfig.new("MyImage")
    |> ImageConfig.add(mount_point)
    ```
  """
  @spec add_mount_point(RemoteDockers.ImageConfig, Map.t) :: RemoteDockers.ImageConfig
  def add_mount_point(%RemoteDockers.ImageConfig{} = image_config, %{} = mount_point) do
    host_config = Map.get(image_config, :HostConfig)

    mount_points =
      Map.get(host_config, :Mounts)
      |> List.insert_at(-1, mount_point)

    host_config = Map.put(host_config, :Mounts, mount_points)
    image_config
    |> Map.put(:HostConfig, host_config)
  end

  @doc """
  Add a volume mount point binding to the image configuration.

  `source` and `target` values are respectively mapped to the `"Source"` and `"Target"` mount point
  description fields.

  See `add_mount_point/2`
  """
  @spec add_mount_point(RemoteDockers.ImageConfig, bitstring, bitstring) :: RemoteDockers.ImageConfig
  def add_mount_point(%RemoteDockers.ImageConfig{} = image_config, source, target) do
    mount = %{
      "Source": source,
      "Target": target,
      "Type": "bind"
    }
    add_mount_point(image_config, mount)
  end

end
