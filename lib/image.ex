defmodule RemoteDockers.Image do
  alias RemoteDockers.{Client, NodeConfig}

  @moduledoc """
  Connector to manage images
  """
  @enforce_keys [:node_config, :id]
  defstruct [
    :node_config,
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
  @spec list!(NodeConfig.t()) :: list(RemoteDockers.Image)
  def list!(%NodeConfig{} = node_config) do
    response =
      Client.build_endpoint(@images_uri)
      |> Client.build_uri(node_config)
      |> Client.get!([], NodeConfig.get_options(node_config))

    case response.status_code do
      200 ->
        Enum.map(response.body, fn image ->
          to_image(image, node_config)
        end)

      _ ->
        raise "unable to list images"
    end
  end

  def list!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  List all images (with children)
  """
  @spec list_all!(NodeConfig.t()) :: list(RemoteDockers.Image)
  def list_all!(%NodeConfig{} = node_config) do
    options =
      NodeConfig.get_options(node_config)
      |> Keyword.put(:query, %{"all" => true})

    response =
      Client.build_endpoint(@images_uri)
      |> Client.build_uri(node_config)
      |> Client.get!([], options)

    case response.status_code do
      200 ->
        Enum.map(response.body, fn image ->
          to_image(image, node_config)
        end)

      _ ->
        raise "unable to list all images"
    end
  end

  def list_all!(_), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  Pull a Docker image from a repository.

  The `name` parameter is the name of the image to pull. It may include
  a tag or digest.
  For instance, use `hello-world:latest` to pull the latest version of
  the `hello-world` image.

  """
  @spec pull!(NodeConfig.t(), bitstring) :: list(Map.t())
  def pull!(%NodeConfig{} = node_config, name) do
    options = NodeConfig.get_options(node_config)

    response =
      Client.build_endpoint(@images_uri, "/create?fromImage=" <> name)
      |> Client.build_uri(node_config)
      |> Client.post!("", [], options)

    case response.status_code do
      200 -> format_status(response.body)
      _ -> raise "unable to pull image with name: " <> name
    end
  end

  def pull!(_, _), do: raise(ArgumentError.exception("Invalid NodeConfig type"))

  @doc """
  Delete a Docker image on a Node.
  """
  @spec delete!(Image.t()) :: list(Map.t())
  def delete!(%RemoteDockers.Image{} = image) do
    options = NodeConfig.get_options(image.node_config)

    response =
      Client.build_endpoint(@images_uri, "/" <> image.id <> "?force=true")
      |> Client.build_uri(image.node_config)
      |> Client.delete!(options)

    case response.status_code do
      200 -> format_status(response.body)
      _ -> raise "unable to delete image with id: " <> image.id
    end
  end

  def delete!(_, _), do: raise(ArgumentError.exception("Invalid Image type"))

  defp to_image(%{} = image, %NodeConfig{} = node_config) do
    %RemoteDockers.Image{
      node_config: node_config,
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

  defp format_status(steps, prev_id \\ nil, result \\ [])
  defp format_status([], _prev_id, result), do: result

  defp format_status([step | steps], prev_id, result) do
    {step, id} =
      case Map.get(step, "id", nil) do
        nil ->
          step =
            case Map.get(step, "error", nil) do
              nil -> Map.put(step, "id", prev_id)
              _ -> step
            end

          {step, prev_id}

        id ->
          {step, id}
      end

    result = List.insert_at(result, -1, step)
    format_status(steps, id, result)
  end
end
