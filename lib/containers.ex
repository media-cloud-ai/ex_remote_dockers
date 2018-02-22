defmodule ExRemoteDockers.Containers do
  @moduledoc """
  Connector for managing remote Docker containers
  """

  @api_version "/#{Application.get_env(:ex_remote_dockers, :version)}"
  @containers_uri "/containers"

  @doc """
  Returns a list of running containers
  """
  def list(%HostConfig{} = host) do
    basic_url(host, "json")
    |> ExRemoteDockers.Client.get()
  end

  @doc """
  Returns a list of all containers
  """
  def list_all(%HostConfig{} = host) do
    basic_url(host, "json")
    |> ExRemoteDockers.Client.get([all: true])
  end

  @doc """
  Create a container
  """
  def create(%HostConfig{} = host, name, query) do
    query =
      query
      |> Poison.encode!
    basic_url(host, "create")
    |> ExRemoteDockers.Client.post([name: name, body: query])
  end

  @doc """
  Remove a container
  """
  def remove(%HostConfig{} = host, container_id) do
    basic_url(host, container_id)
    |> ExRemoteDockers.Client.delete()
  end

  @doc """
  Start a container
  """
  def start(%HostConfig{} = host, container_id) do
    basic_url(host, container_id <> "/start")
    |> ExRemoteDockers.Client.post()
  end

  @doc """
  Stop a container
  """
  def stop(%HostConfig{} = host, container_id) do
    basic_url(host, container_id <> "/stop")
    |> ExRemoteDockers.Client.post()
  end

  @doc """
  Return low-level information about a container
  """
  def inspect(%HostConfig{} = host, container_id) do
    basic_url(host, container_id <> "/json")
    |> ExRemoteDockers.Client.get()
  end


  defp basic_url(%HostConfig{} = host_config, uri) do
    uri = check_uri(uri)
    # uri = check_parameters(uri, parameters)

    host_config.host <> ":" <> host_config.port <> @api_version <> @containers_uri <> uri
  end

  defp check_uri(uri) do
    unless String.starts_with? uri, "/" do
      "/" <> uri
    end
  end

end
