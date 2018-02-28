defmodule RemoteDockers.ImageTest do
  use ExUnit.Case
  alias RemoteDockers.{Image, HostConfig}
  doctest RemoteDockers.Image

  test "list containers" do
    host_config = HostConfig.build("https://192.168.99.100", "/Users/marco/.docker/machine/certs/cert.pem", "/Users/marco/.docker/machine/certs/key.pem")
    images = Image.list!(host_config)
    assert is_list(images.body)
  end
end
