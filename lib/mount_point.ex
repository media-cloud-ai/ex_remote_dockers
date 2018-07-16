defmodule RemoteDockers.MountPoint do
  @moduledoc """
  Mount point description for the Docker Containers API
  """

  @enforce_keys [:Source, :Target, :Type]
  defstruct [
    :Source,
    :Target,
    :Type,
    :ReadOnly,
    :Consistency
  ]

  @doc """
  Build a new mount point description.

  ## Example:
    ```elixir
    iex> MountPoint.new("source_path", "target_path")
    %MountPoint{:Source => "source_path", :Target => "target_path", :Type => "bind"}

    iex> MountPoint.new("/path/in/host", "/path/in/container", "volume")
    %MountPoint{:Source => "/path/in/host", :Target => "/path/in/container", :Type => "volume"}
    ```
  """
  def new(source, target, type \\ "bind") do
    %RemoteDockers.MountPoint{
      Source: source,
      Target: target,
      Type: type
    }
  end
end
