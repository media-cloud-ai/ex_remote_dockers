defmodule RemoteDockers.ImageConfigTest do
  use ExUnit.Case
  alias RemoteDockers.ImageConfig
  doctest RemoteDockers.ImageConfig

  test "default configuration" do
    image_name = "hello-world"
    assert ImageConfig.new(image_name) == %ImageConfig{:Image => image_name, :Env => [], :HostConfig => %{:Mounts => []}}
  end

  test "add env" do
    image_name = "hello-world"
    image_config =
      ImageConfig.new(image_name)
      |> ImageConfig.add_env("TOTO", "/path/to/toto")

    assert image_config == %ImageConfig{
        :Image => image_name,
        :Env => ["TOTO=/path/to/toto"],
        :HostConfig => %{
          :Mounts => []
        }
      }
  end

  test "add mount point" do
    image_name = "hello-world"
    image_config =
      ImageConfig.new(image_name)
      |> ImageConfig.add_mount_point("/path/to/a/host/mount/point", "/path/to/a/container/directory")
      |> ImageConfig.add_mount_point("/path/to/another/host/mount/point", "/path/to/another/container/directory")

    assert image_config == %ImageConfig{
        :Image => image_name,
        :Env => [],
        :HostConfig => %{
          :Mounts => [
            %{
              :Source => "/path/to/a/host/mount/point",
              :Target => "/path/to/a/container/directory",
              :Type => "bind"
            },
            %{
              :Source => "/path/to/another/host/mount/point",
              :Target => "/path/to/another/container/directory",
              :Type => "bind"
            }
          ]
        }
      }
  end

end
