defmodule RemoteDockers.ContainerConfig do
  alias RemoteDockers.MountPoint

  @enforce_keys [:Image]
  defstruct [
    :Env,
    :HostConfig,
    :Image,
    :User,
    :WorkingDir,
    :Entrypoint,
    :Cmd
  ]

  @doc """
  Build a container configuration with a specified `image_name`.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{}
    }
    ```
  """
  def new(image_name) do
    %RemoteDockers.ContainerConfig{
      Env: [],
      HostConfig: %{},
      Image: image_name
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
      :HostConfig => %{},
    }
    ```
  """
  @spec add_env(RemoteDockers.ContainerConfig, bitstring, bitstring) ::
          RemoteDockers.ContainerConfig
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
  @spec add_mount_point(RemoteDockers.ContainerConfig, MountPoint) ::
          RemoteDockers.ContainerConfig
  def add_mount_point(
        %RemoteDockers.ContainerConfig{} = container_config,
        %MountPoint{} = mount_point
      ) do
    mount_points =
      container_config
      |> Map.get(:HostConfig, %{})
      |> Map.get(:Mounts, [])
      |> List.insert_at(-1, mount_point)

    update_host_config(container_config, :Mounts, mount_points)
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
  @spec add_mount_point(RemoteDockers.ContainerConfig, bitstring, bitstring, bitstring) ::
          RemoteDockers.ContainerConfig
  def add_mount_point(
        %RemoteDockers.ContainerConfig{} = container_config,
        source,
        target,
        type \\ "bind"
      ) do
    add_mount_point(container_config, MountPoint.new(source, target, type))
  end

  @doc """
  Add a DNS option to the container configuration.

  See `add_dns_option/2`

  ## Example:
    ```elixir
    iex> ContainerConfig.new("image_name")
    ...> |> ContainerConfig.add_dns_option("dns option")
    %ContainerConfig{
      :Image => "image_name",
      :Env => [],
      :HostConfig => %{
        :DnsOptions => ["dns option"],
      }
    }
    ```
  """
  @spec add_dns_option(RemoteDockers.ContainerConfig, bitstring) :: RemoteDockers.ContainerConfig
  def add_dns_option(
        %RemoteDockers.ContainerConfig{} = container_config,
        dns_option
      ) do
    dns_options =
      container_config
      |> Map.get(:HostConfig, %{})
      |> Map.get(:DnsOptions, [])
      |> List.insert_at(-1, dns_option)

    update_host_config(container_config, :DnsOptions, dns_options)
  end

  @doc """
  Add an extra Host to the container configuration.

  See `add_extra_host/3`

  ## Example:
    ```elixir
    iex> ContainerConfig.new("image_name")
    ...> |> ContainerConfig.add_extra_host("my_host", "192.168.10.10")
    %ContainerConfig{
      :Image => "image_name",
      :Env => [],
      :HostConfig => %{
        :ExtraHosts => ["my_host:192.168.10.10"],
      }
    }
    ```
  """
  @spec add_extra_host(RemoteDockers.ContainerConfig, bitstring, bitstring) ::
          RemoteDockers.ContainerConfig
  def add_extra_host(
        %RemoteDockers.ContainerConfig{} = container_config,
        hostname,
        ip
      ) do
    extra_hosts =
      container_config
      |> Map.get(:HostConfig, %{})
      |> Map.get(:ExtraHosts, [])
      |> List.insert_at(-1, hostname <> ":" <> ip)

    update_host_config(container_config, :ExtraHosts, extra_hosts)
  end

  @doc """
  Add parameter to the HostConfig element.

  See `update_host_config/3`

  ## Example:
    ```elixir
    iex> ContainerConfig.new("image_name")
    ...> |> ContainerConfig.update_host_config(:my_custom_key, :my_custom_value)
    %ContainerConfig{
      :Image => "image_name",
      :Env => [],
      :HostConfig => %{
        :my_custom_key => :my_custom_value,
      }
    }
    ```
  """
  @spec update_host_config(RemoteDockers.ContainerConfig, bitstring, any) ::
          RemoteDockers.ContainerConfig
  def update_host_config(
        %RemoteDockers.ContainerConfig{} = container_config,
        key,
        value
      ) do
    host_config =
      container_config
      |> Map.get(:HostConfig, %{})
      |> Map.put(key, value)

    container_config
    |> Map.put(:HostConfig, host_config)
  end

  @doc """
  Set the user that commands are run as.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_user("username")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :User => "username"
    }
    ```
  """
  @spec set_user(RemoteDockers.ContainerConfig, bitstring) :: RemoteDockers.ContainerConfig
  def set_user(
        %RemoteDockers.ContainerConfig{} = container_config,
        user
      ) do
    container_config
    |> Map.put(:User, user)
  end

  @doc """
  Set the working directory that commands are run in.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_working_dir("/app")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :WorkingDir => "/app"
    }
    ```
  """
  @spec set_working_dir(RemoteDockers.ContainerConfig, bitstring) :: RemoteDockers.ContainerConfig
  def set_working_dir(
        %RemoteDockers.ContainerConfig{} = container_config,
        working_dir
      ) do
    container_config
    |> Map.put(:WorkingDir, working_dir)
  end

  @doc """
  Set the entry point for the container.

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_entrypoint("iex -s mix")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :Entrypoint => "iex -s mix"
    }
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_entrypoint(["/usr/local/bin/iex", "-s", "mix"])
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :Entrypoint => ["/usr/local/bin/iex", "-s", "mix"]
    }
    ```
  """
  @spec set_entrypoint(RemoteDockers.ContainerConfig, bitstring | list(bitstring)) ::
          RemoteDockers.ContainerConfig
  def set_entrypoint(
        %RemoteDockers.ContainerConfig{} = container_config,
        entrypoint
      ) do
    container_config
    |> Map.put(:Entrypoint, entrypoint)
  end

  @doc """
  Set the command to run

  ## Example:
    ```elixir
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_command("iex -s mix")
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :Cmd => "iex -s mix"
    }
    iex> ContainerConfig.new("hello-world")
    ...> |> ContainerConfig.set_command(["/usr/local/bin/iex", "-s", "mix"])
    %ContainerConfig{
      :Image => "hello-world",
      :Env => [],
      :HostConfig => %{},
      :Cmd => ["/usr/local/bin/iex", "-s", "mix"]
    }
    ```
  """
  @spec set_command(RemoteDockers.ContainerConfig, bitstring | list(bitstring)) ::
          RemoteDockers.ContainerConfig
  def set_command(
        %RemoteDockers.ContainerConfig{} = container_config,
        command
      ) do
    container_config
    |> Map.put(:Cmd, command)
  end

  defimpl Jason.Encoder do
    def encode(value, opts) do
      # encode as a map, but drop any unspecified values
      value
      |> Map.from_struct()
      |> Map.to_list()
      |> Enum.filter(fn {_name, value} -> value != nil end)
      |> Map.new()
      |> Jason.Encode.map(opts)
    end
  end
end
