defmodule RemoteDockers.ImageTest do
  use ExUnit.Case
  alias RemoteDockers.{Image, HostConfig}
  doctest RemoteDockers.Image

  @host_config HostConfig.build(
    Application.get_env(:remote_dockers, :hostname),
    Application.get_env(:remote_dockers, :port),
    Application.get_env(:remote_dockers, :certfile),
    Application.get_env(:remote_dockers, :keyfile)
  )

  test "list images" do
    images = Image.list!(@host_config)
    assert is_list(images)
  end

  test "fail listing images" do
    assert_raise(ArgumentError, "Invalid host config type", fn -> Image.list!("host_config") end)
  end

  test "list all images" do
    images = Image.list_all!(@host_config)
    assert is_list(images)
  end

  test "fail listing all images" do
    assert_raise(ArgumentError, "Invalid host config type", fn -> Image.list_all!("host_config") end)
  end

  test "pull an image" do
    status = Image.pull!(@host_config, "hello-world:latest")
    assert is_list(status)
  end

  test "fail pulling an images" do
    assert_raise(ArgumentError, "Invalid host config type", fn -> Image.pull!("host_config", "hello-world") end)
  end

end
