defmodule RemoteDockers.HostConfigTest do
  use ExUnit.Case
  alias RemoteDockers.HostConfig
  doctest RemoteDockers.HostConfig

  test "default configuration" do
    assert HostConfig.new() == %HostConfig{hostname: "localhost", port: 2376}
  end

  test "custom hostname" do
    assert HostConfig.new("192.168.99.100")
             == %HostConfig{hostname: "192.168.99.100", port: 2376}
  end

  test "custom hostname and port" do
    assert HostConfig.new("192.168.99.100", 2345)
             == %HostConfig{hostname: "192.168.99.100", port: 2345}
  end

  test "custom hostname and SSL configuration" do
    assert HostConfig.new("192.168.99.100", "cert.pem", "key.pem")
             == %HostConfig{hostname: "192.168.99.100", port: 2376, ssl: [certfile: "cert.pem", keyfile: "key.pem"]}
  end

  test "custom hostname and port and SSL configuration" do
    assert HostConfig.new("192.168.99.100", 2345, "cert.pem", "key.pem")
             == %HostConfig{hostname: "192.168.99.100", port: 2345, ssl: [certfile: "cert.pem", keyfile: "key.pem"]}
  end
end
