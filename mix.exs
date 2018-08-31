defmodule RemoteDockers.MixProject do
  use Mix.Project

  def project do
    [
      app: :remote_dockers,
      version: get_version(),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),

      # Docs
      name: "RemoteDockers",
      source_url: "https://github.com/FTV-Subtil/ex_remote_dockers",
      homepage_url: "https://github.com/FTV-Subtil/ex_remote_dockers",
      docs: [
        main: "RemoteDockers",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :httpoison
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.3"},
      {:poison, "~> 4.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Elixir library to manage containers from several remote dockers, using the Docker Engine API v1.35."
  end

  defp package() do
    [
      name: "remote_dockers",
      files: ["lib", "mix.exs", "README*", "LICENSE*", "VERSION"],
      maintainers: [
        "Valentin Noël",
        "Marc-Antoine Arnaud"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/FTV-Subtil/ex_remote_dockers"}
    ]
  end

  defp get_version do
    version_from_file()
    |> handle_file_version()
    |> String.replace_leading("v", "")
  end

  defp version_from_file(file \\ "VERSION") do
    File.read(file)
  end

  defp handle_file_version({:ok, content}) do
    content
  end

  defp handle_file_version({:error, _}) do
    retrieve_version_from_git()
  end

  defp retrieve_version_from_git do
    require Logger

    Logger.warn(
      "Calling out to `git describe` for the version number. This is slow! You should think about a hook to set the VERSION file"
    )

    System.cmd("git", ~w{describe --always --tags --first-parent})
    |> elem(0)
    |> String.trim()
  end
end
