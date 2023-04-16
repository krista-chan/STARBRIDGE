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
    ["DISCORD_ENABLED", val] = File.read!(".env")
    |> String.split(~r/(\n|\r\n)/)
    |> Enum.reject(fn e -> String.length(e) == 0 end)
    |> Enum.find(fn ent ->
      {k,_v} = String.split(ent, "=")
      |> List.to_tuple()
      k == "DISCORD_ENABLED"
    end)
    |> String.split("=")

    run_discord = !!String.to_existing_atom(val)
    |> IO.inspect

    [
      {:nostrum, "~> 0.6.1", runtime: run_discord},
      {:exirc, "~> 2.0.0"},
      {:dotenvy, "~> 0.7.0"},
      {:polyjuice_client, "~> 0.4.4"},
    ]
  end
end
