defmodule RemoteDockers.Image do
  alias RemoteDockers.{Client, HostConfig}
  @moduledoc """
  Connector to manage images
  """
  @enforce_keys [:host_config, :id]
  defstruct [
    :host_config,
    :id,
    :containers,
    :created,
    :labels,
    :parent_id,
    :repo_tags,
    :repo_digests,
    :shared_size,
    :size,
    :virtual_size
  ]

  @images_uri "/images"

  @doc """
  Returns a list of images
  """
  def list!(host_config) do
    response =
      Client.build_endpoint(@images_uri)
      |> Client.build_uri(host_config)
      |> Client.get!([], HostConfig.get_options(host_config))

    case response.status_code do
      200 -> Enum.map(response.body, fn(image) -> to_image(image, host_config) end)
      _ -> raise "unable to list images"
    end
  end

  @doc """
  List all images (with children)
  """
  def list_all!(host_config) do
    options =
      HostConfig.get_options(host_config)
      |> Keyword.put(:query, %{"all" => true})

    response =
      Client.build_endpoint(@images_uri)
      |> Client.build_uri(host_config)
      |> Client.get!([], options)

    case response.status_code do
      200 -> Enum.map(response.body, fn(image) -> to_image(image, host_config) end)
      _ -> raise "unable to list all images"
    end
  end

  defp to_image(%{} = image, %HostConfig{} = host_config) do
    %RemoteDockers.Image{
      host_config: host_config,
      id: image["Id"],
      containers: image["Containers"],
      created: image["Created"],
      labels: image["Labels"],
      parent_id: image["ParentId"],
      repo_tags: image["RepoTags"],
      repo_digests: image["RepoDigests"],
      shared_size: image["SharedSize"],
      size: image["Size"],
      virtual_size: image["VirtualSize"]
    }
  end
end
