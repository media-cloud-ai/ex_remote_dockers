defmodule ExRemoteDockers.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_remote_dockers,
      version: "0.1.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),

      # Docs
      name: "ExRemoteDockers",
      source_url: "https://github.com/FTV-Subtil/ex_remote_dockers",
      homepage_url: "https://github.com/FTV-Subtil/ex_remote_dockers",
      docs: [
        main: "ExRemoteDockers",
          extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Elixir library to manage containers from several remote dockers, using the Docker Engine API v1.35."
  end

  defp package() do
    [
      name: "ex_remote_dockers",
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
