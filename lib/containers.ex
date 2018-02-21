defmodule ExRemoteDockers.Containers do
  @moduledoc """
  Connector for managing remote Docker containers
  """

  @api_version "/#{Application.get_env(:ex_remote_dockers, :version)}"
  @containers_uri "/containers"

  @doc """
  Returns a list of running containers
  """
  def list(host) do
    ExRemoteDockers.Client.get(basic_url(host, "json"))
  end

  @doc """
  Returns a list of all containers
  """
  def list_all(host) do
    ExRemoteDockers.Client.get(basic_url(host, "json", "all=true"))
  end

  @doc """
  Create a container
  """
  def create(host, name, query) do
    query =
      query
      |> Poison.encode!
    ExRemoteDockers.Client.post(basic_url(host, "create", "name=" <> name), [body: query])
  end

  @doc """
  Remove a container
  """
  def remove(host, container_id) do
    ExRemoteDockers.Client.delete(basic_url(host, container_id))
  end

  @doc """
  Start a container
  """
  def start(host, container_id) do
    ExRemoteDockers.Client.post(basic_url(host, container_id <> "/start"))
  end

  @doc """
  Stop a container
  """
  def stop(host, container_id) do
    ExRemoteDockers.Client.post(basic_url(host, container_id <> "/stop"))
  end

  @doc """
  Return low-level information about a container
  """
  def inspect(host, container_id) do
    ExRemoteDockers.Client.get(basic_url(host, container_id <> "/json"))
  end


  defp basic_url(host, uri, parameters) do
    uri = check_uri(uri)
    uri = check_parameters(uri, parameters)

    host <> @api_version <> @containers_uri <> uri
  end

  defp basic_url(host, uri) do
    basic_url(host, uri, nil)
  end

  defp check_uri(uri) do
    unless String.starts_with? uri, "/" do
      "/" <> uri
    end
  end

  defp check_parameters(uri, parameters) when is_nil(parameters) do
    uri
  end

  defp check_parameters(uri, parameters) do
    uri =
      unless String.starts_with? parameters, "?" do
        uri <> "?"
      end
    uri <> parameters
  end

end
