defmodule RemoteDockers.NodeConfig do
  @enforce_keys [:hostname, :port]
  defstruct [:hostname, :port, :ssl, :label]

  @default_port 2376

  @doc """
  Build configuration with defaults

  default:
  ```
  hostname: "localhost"
  port: #{@default_port}
  ```

  ## Example:
    ```elixir
    iex> NodeConfig.new()
    %NodeConfig{hostname: "localhost", port: 2376}
    ```
  """
  def new() do
    new("localhost", @default_port)
  end

  @doc """
  Build configuration with a specific hostname

  default:
  ```
  port: #{@default_port}
  ```

  ## Example:
    ```elixir
    iex> NodeConfig.new("192.168.99.100")
    %NodeConfig{hostname: "192.168.99.100", port: 2376}
    ```
  """
  def new(hostname) do
    new(hostname, @default_port)
  end

  @doc """
  Build configuration with specific hostname and port

  ## Example:
    ```elixir
    iex> NodeConfig.new("192.168.99.100", 2345)
    %NodeConfig{hostname: "192.168.99.100", port: 2345}
    ```
  """
  def new(hostname, port) do
    %RemoteDockers.NodeConfig{
      hostname: hostname,
      port: port
    }
  end

  @doc """
  Build configuration with SSL

  default:
  ```
  port: #{@default_port}
  ```

  ## Example:
    ```elixir
    iex> NodeConfig.new("192.168.99.100", "cert.pem", "key.pem")
    %NodeConfig{
      hostname: "192.168.99.100",
      port: 2376,
      ssl: [
        certfile: "cert.pem",
        keyfile: "key.pem"
      ]
    }
    ```
  """
  def new(hostname, nil, nil), do: new(hostname)

  def new(hostname, certfile, keyfile) do
    new(hostname, @default_port, certfile, keyfile)
  end

  @doc """
  Build configuration with hostname, port and SSL

  ## Example:
    ```elixir
    iex> NodeConfig.new("192.168.99.100", 2345, "cert.pem", "key.pem")
    %NodeConfig{
      hostname: "192.168.99.100",
      port: 2345,
      ssl: [
        certfile: "cert.pem",
        keyfile: "key.pem"
      ]
    }
    ```
  """
  def new(hostname, port, nil, nil), do: new(hostname, port)

  def new(hostname, port, certfile, keyfile) do
    %RemoteDockers.NodeConfig{
      hostname: hostname,
      port: port,
      ssl: [
        certfile: certfile,
        keyfile: keyfile
      ]
    }
  end

  @doc """
  Build configuration with hostname, port and SSL with Certificate Authority

  ## Example:
    ```elixir
    iex> NodeConfig.new("192.168.99.100", 2345, "ca.pem", "cert.pem", "key.pem")
    %NodeConfig{
      hostname: "192.168.99.100",
      port: 2345,
      ssl: [
        cacertfile: "ca.pem",
        certfile: "cert.pem",
        keyfile: "key.pem"
      ]
    }
    ```
  """
  def new(hostname, port, nil, nil, nil), do: new(hostname, port)

  def new(hostname, port, nil, certfile, keyfile), do: new(hostname, port, certfile, keyfile)

  def new(hostname, port, cacertfile, certfile, keyfile) do
    %RemoteDockers.NodeConfig{
      hostname: hostname,
      port: port,
      ssl: [
        cacertfile: cacertfile,
        certfile: certfile,
        keyfile: keyfile
      ]
    }
  end

  @doc """
  Set label for this configuration
  ## Example:
    ```elixir
    iex> NodeConfig.new() |> NodeConfig.set_label("My Local Node")
    %NodeConfig{
      hostname: "localhost",
      port: 2376,
      label: "My Local Node"
    }
    ```
  """
  def set_label(%RemoteDockers.NodeConfig{} = node_config, label) do
    Map.put(node_config, :label, label)
  end

  @doc """
  Get HTTPoison default options with ssl if enabled
  """
  def get_options(%RemoteDockers.NodeConfig{ssl: nil} = _node_config), do: []

  def get_options(node_config) do
    [
      ssl: node_config.ssl
    ]
  end
end
