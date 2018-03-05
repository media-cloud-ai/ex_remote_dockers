defmodule RemoteDockers.DockerHostConfig do
  @enforce_keys [:hostname, :port]
  defstruct [:hostname, :port, :ssl]

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
    iex> DockerHostConfig.new()
    %DockerHostConfig{hostname: "localhost", port: 2376}
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
    iex> DockerHostConfig.new("192.168.99.100")
    %DockerHostConfig{hostname: "192.168.99.100", port: 2376}
    ```
  """
  def new(hostname) do
    new(hostname, @default_port)
  end

  @doc """
  Build configuration with specific hostname and port

  ## Example:
    ```elixir
    iex> DockerHostConfig.new("192.168.99.100", 2345)
    %DockerHostConfig{hostname: "192.168.99.100", port: 2345}
    ```
  """
  def new(hostname, port) do
    %RemoteDockers.DockerHostConfig{
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
    iex> DockerHostConfig.new("192.168.99.100", "cert.pem", "key.pem")
    %DockerHostConfig{
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
    iex> DockerHostConfig.new("192.168.99.100", 2345, "cert.pem", "key.pem")
    %DockerHostConfig{
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
    %RemoteDockers.DockerHostConfig{
      hostname: hostname,
      port: port,
      ssl: [
        certfile: certfile,
        keyfile: keyfile,
      ]
    }
  end

  @doc """
  Get HTTPoison default options with ssl if enabled
  """
  def get_options(%RemoteDockers.DockerHostConfig{ssl: nil} = _host_config), do: []
  def get_options(host_config) do
    [
      ssl: host_config.ssl
    ]
  end
end
