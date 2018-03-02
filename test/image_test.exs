defmodule RemoteDockers.ImageTest do
  use ExUnit.Case
  alias RemoteDockers.{Image, HostConfig}
  doctest RemoteDockers.Image

  @host_config HostConfig.build(
    "https://192.168.99.100",
    "/path/to/cert.pem",
    "/path/to/key.pem"
  )

  test "list images" do
    images = Image.list!(@host_config)
    assert is_list(images)
  end

  test "list all images" do
    images = Image.list_all!(@host_config)
    assert is_list(images)
  end

  test "pull an image" do
    status = Image.pull!(@host_config, "hello-world:latest")
    assert is_list(status)
  end

end
