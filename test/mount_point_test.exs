defmodule RemoteDockers.MountPointTest do
  use ExUnit.Case
  alias RemoteDockers.MountPoint
  doctest RemoteDockers.MountPoint

  test "default construction" do
    assert MountPoint.new("/path/in/host", "/path/in/container", "bind") == %MountPoint{
      :Source => "/path/in/host",
      :Target => "/path/in/container",
      :Type => "bind"
    }
  end

end
