defmodule RemoteDockers.MixProject do
  use Mix.Project

  def project do
    [
      app: :remote_dockers,
      version: "1.1.0",
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
        :httpoison,
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Elixir library to manage containers from several remote dockers, using the Docker Engine API v1.35."
  end

  defp package() do
    [
      name: "remote_dockers",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: [
        "Valentin Noël",
        "Marc-Antoine Arnaud"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/FTV-Subtil/ex_remote_dockers"}
    ]
  end
end
