defmodule RemoteDockers.HostConfig do
  @enforce_keys [:hostname, :port]
  defstruct [:hostname, :port, :ssl]

  @doc """
  Build configuration with defaults

  default:
  ```
  hostname: "localhost"
  port: 2376
  ```
  """
  def build() do
    %RemoteDockers.HostConfig{
      hostname: "localhost",
      port: 2376
    }
  end

  @doc """
  Build configuration with a specific hostname

  default:
  ```
  port: 2376
  ```
  """
  def build(hostname) do
    %RemoteDockers.HostConfig{
      hostname: hostname,
      port: 2376
    }
  end

  @doc """
  Build configuration with SSL

  default:
  ```
  port: 2376
  ```
  """
  def build(hostname, certfile, keyfile) do
    %RemoteDockers.HostConfig{
      hostname: hostname,
      port: 2376,
      ssl: [
        certfile: certfile,
        keyfile: keyfile,
      ]
    }
  end

  @doc """
  Get HTTPoison default options with ssl if enabled
  """
  def get_options(%RemoteDockers.HostConfig{ssl: nil} = _host_config), do: []
  def get_options(host_config) do
    [
      ssl: host_config.ssl
    ]
  end
end
