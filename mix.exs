defmodule Starbridge.MixProject do
  use Mix.Project

  def project do
    [
      app: :starbridge,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      # applications: [:exirc],
      mod: {Starbridge.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.6.1"},
      {:exirc, "~> 2.0.0"},
      {:dotenvy, "~> 0.7.0"},
      {:polyjuice_client, "~> 0.4.4"},
    ]
  end
end
