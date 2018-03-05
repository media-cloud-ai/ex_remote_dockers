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
  """
  def new(source, target, type) do
    %RemoteDockers.MountPoint{
      "Source": source,
      "Target": target,
      "Type": type
    }
  end

end
