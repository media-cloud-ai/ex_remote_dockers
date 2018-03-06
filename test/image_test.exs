defmodule RemoteDockers.ImageTest do
  use ExUnit.Case
  alias RemoteDockers.{Image, NodeConfig}
  doctest RemoteDockers.Image

  @node_config NodeConfig.new(
    Application.get_env(:remote_dockers, :hostname),
    Application.get_env(:remote_dockers, :port),
    Application.get_env(:remote_dockers, :certfile),
    Application.get_env(:remote_dockers, :keyfile)
  )

  test "list images" do
    images = Image.list!(@node_config)
    assert is_list(images)
  end

  test "fail listing images" do
    assert_raise(ArgumentError, "Invalid NodeConfig type", fn -> Image.list!("node_config") end)
  end

  test "list all images" do
    images = Image.list_all!(@node_config)
    assert is_list(images)
  end

  test "fail listing all images" do
    assert_raise(ArgumentError, "Invalid NodeConfig type", fn -> Image.list_all!("node_config") end)
  end

  test "pull an image" do
    status = Image.pull!(@node_config, "hello-world:latest")
    assert is_list(status)
  end

  test "fail pulling an images" do
    assert_raise(ArgumentError, "Invalid NodeConfig type", fn -> Image.pull!("node_config", "hello-world") end)
  end

end
