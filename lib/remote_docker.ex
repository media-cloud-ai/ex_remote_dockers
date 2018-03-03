defmodule RemoteDockers do
  @moduledoc """
  Elixir wrapper to drive Docker nodes.

  Before using this library, ensure your Docker instance is serving the HTTP API (by default, the service is generally listening to a socket).

  This library supports the connection with SSL certificat (HTTPS).

  ### Supported endpoints

  - `RemoteDockers.Image`
    manage docker image (list, pull, build, delete)
  - `RemoteDockers.Container`
    manage docker container (list, start, stop, delete)
  """
end
