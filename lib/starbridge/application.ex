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
    {:ok, pid} =
      Polyjuice.Client.start_link(
        env(:matrix_address),
        access_token: env(:matrix_token),
        user_id: env(:matrix_user),
        storage: Polyjuice.Client.Storage.Ets.open(),
        handler: self()
      )

    children = [
      Starbridge.Discord,
      {Starbridge.IRC, client},
      {Starbridge.Matrix, pid},
      Starbridge.Server,
    ]
    opts = [strategy: :one_for_one, name: Starbridge.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
