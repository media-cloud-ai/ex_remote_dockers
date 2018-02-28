defmodule RemoteDockers.HostConfigTest do
  use ExUnit.Case
  alias RemoteDockers.HostConfig
  doctest RemoteDockers.HostConfig

  test "default configuration" do
    assert HostConfig.build() == %HostConfig{hostname: "localhost", port: 2376}
  end

  test "custom hostname" do
    assert HostConfig.build("192.168.99.100") == %HostConfig{hostname: "192.168.99.100", port: 2376}
  end

  test "SSL configuration" do
    assert HostConfig.build("192.168.99.100", "cert.pem", "key.pem") == %HostConfig{hostname: "192.168.99.100", port: 2376, ssl: [certfile: "cert.pem", keyfile: "key.pem"]}
  end
end
