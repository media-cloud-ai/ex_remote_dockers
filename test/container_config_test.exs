defmodule RemoteDockers.ContainerConfigTest do
  use ExUnit.Case
  alias RemoteDockers.{
    ContainerConfig,
    MountPoint
  }
  doctest RemoteDockers.ContainerConfig

  test "default configuration" do
    image_name = "hello-world"
    assert ContainerConfig.new(image_name) == %ContainerConfig{:Image => image_name, :Env => [], :HostConfig => %{:Mounts => []}}
  end

  test "add env" do
    image_name = "hello-world"
    container_config =
      ContainerConfig.new(image_name)
      |> ContainerConfig.add_env("TOTO", "/path/to/toto")

    assert container_config == %ContainerConfig{
        :Image => image_name,
        :Env => ["TOTO=/path/to/toto"],
        :HostConfig => %{
          :Mounts => []
        }
      }
  end

  test "add mount point" do
    image_name = "hello-world"
    container_config =
      ContainerConfig.new(image_name)
      |> ContainerConfig.add_mount_point("/path/to/a/host/mount/point", "/path/to/a/container/directory")
      |> ContainerConfig.add_mount_point("/path/to/another/host/mount/point", "/path/to/another/container/directory")

    assert container_config == %ContainerConfig{
        :Image => image_name,
        :Env => [],
        :HostConfig => %{
          :Mounts => [
            %MountPoint{
              :Source => "/path/to/a/host/mount/point",
              :Target => "/path/to/a/container/directory",
              :Type => "bind"
            },
            %MountPoint{
              :Source => "/path/to/another/host/mount/point",
              :Target => "/path/to/another/container/directory",
              :Type => "bind"
            }
          ]
        }
      }
  end

end
