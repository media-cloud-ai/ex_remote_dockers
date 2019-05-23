use Mix.Config

config :remote_dockers,
  hostname: "https://192.168.64.2",
  port: 2376,
  cacertfile: "/Users/marco/.docker/machine/machines/default/ca.pem",
  certfile: "/Users/marco/.docker/machine/machines/default/cert.pem",
  keyfile: "/Users/marco/.docker/machine/machines/default/key.pem"
