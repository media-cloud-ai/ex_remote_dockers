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

  @doc """
  Pull a Docker image from a repository.

  The `name` parameter is the name of the image to pull. It may include
  a tag or digest.
  For instance, use `hello-world:latest` to pull the latest version of
  the `hello-world` image.

  """
  def pull!(host_config, name) do
    options =
      HostConfig.get_options(host_config)

    response =
      Client.build_endpoint(@images_uri, "/create?fromImage=" <> name)
      |> Client.build_uri(host_config)
      |> Client.post!([], options)

    case response.status_code do
      200 -> to_pull_status(response.body)
      _ -> raise "unable to pull a " <> name <> " image"
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

  defp to_pull_status(steps) do
    steps
    |> Enum.map_reduce("", fn step, acc ->
        acc
          |> get_id(step["id"])
          |> put_id(step)
      end)
    |> elem(0)
  end

  defp get_id(acc, id) when is_nil(id), do: acc
  defp get_id(_acc, id), do: id

  defp put_id(acc, %{"error" => _error} = step), do: {step, acc}
  defp put_id(acc, step), do: {Map.put(step, "id", acc), acc}

end
