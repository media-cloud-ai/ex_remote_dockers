defmodule RemoteDockers do
  @moduledoc """
  Elixir wrapper to drive Docker nodes.

  Before try this library, be sure your docker machine will serve the API on HTTP (on some OS, default is on a socket).

  This library support the connection with SSL certificat.

  ### Supported endpoints

  - `RemoteDockers.Image`
    manage docker image (list, pull, build, delete)
  - `RemoteDockers.Container`
    manage docker container (list, start, stop, delete)
  """
end
