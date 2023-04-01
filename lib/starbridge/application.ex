defmodule Starbridge.Application do
  use Application
  import Starbridge.Env

  @impl true
  def start(_ty, _args) do
    # :dbg.start
    # :dbg.tracer
    # :dbg.tp(:gen_tcp, :send, 2, [])
    # :dbg.p(:all, :c)

    {:ok, client} = ExIRC.start_link!

    client_modules = [
      {env(:discord_enabled), Starbridge.Discord},
      {env(:irc_enabled),    {Starbridge.IRC, client}},
      {env(:matrix_enabled),  Starbridge.Matrix},
    ]

    children =
      Enum.filter(client_modules, fn {enabled, _child} -> enabled end)
      |> Enum.map(fn {_enabled, child} -> child end)

    opts = [strategy: :one_for_one, name: Starbridge.Supervisor]

    Supervisor.start_link([Starbridge.Server | children], opts)
  end
end
