defmodule RemoteDockers.DockerHostConfigTest do
  use ExUnit.Case
  alias RemoteDockers.DockerHostConfig
  doctest RemoteDockers.DockerHostConfig

  test "default configuration" do
    assert DockerHostConfig.new() == %DockerHostConfig{hostname: "localhost", port: 2376}
  end

  test "custom hostname" do
    assert DockerHostConfig.new("192.168.99.100")
             == %DockerHostConfig{hostname: "192.168.99.100", port: 2376}
  end

  test "custom hostname and port" do
    assert DockerHostConfig.new("192.168.99.100", 2345)
             == %DockerHostConfig{hostname: "192.168.99.100", port: 2345}
  end

  test "custom hostname and SSL configuration" do
    assert DockerHostConfig.new("192.168.99.100", "cert.pem", "key.pem")
             == %DockerHostConfig{hostname: "192.168.99.100", port: 2376, ssl: [certfile: "cert.pem", keyfile: "key.pem"]}
  end

  test "custom hostname and port and SSL configuration" do
    assert DockerHostConfig.new("192.168.99.100", 2345, "cert.pem", "key.pem")
             == %DockerHostConfig{hostname: "192.168.99.100", port: 2345, ssl: [certfile: "cert.pem", keyfile: "key.pem"]}
  end
end
