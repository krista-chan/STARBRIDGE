defmodule Starbridge.Matrix do
  alias Starbridge.Server
  import Starbridge.Env
  require Starbridge.Logger, as: Logger
  use GenServer

  def start_link(_) do
    {:ok, handler_pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)

    {:ok, pid} =
      Polyjuice.Client.start_link(
        env(:matrix_address),
        access_token: env(:matrix_token),
        user_id: env(:matrix_user),
        storage: Polyjuice.Client.Storage.Ets.open(),
        handler: handler_pid
      )
    client = Polyjuice.Client.get_client(pid)

    :sys.replace_state(handler_pid, fn _ -> client end)

    {:ok, handler_pid}
  end

  @impl true
  def init(client) do
    Server.register(:matrix, __MODULE__)

    env(:matrix_rooms)
    |> String.split(",")
    |> Enum.map(fn r ->
      ret = Polyjuice.Client.Room.join(client, r, [env(:matrix_address)])
      case ret do
        {:ok, room_id} ->
          Logger.debug("Joined #{room_id}.")

        _ ->
          Logger.error("Failed to join #{r}: #{inspect(ret)}")
      end
    end)

    {:ok, client}
  end

  @impl true
  def handle_info(msg, client) do
    Logger.debug("Received unknown message")
    IO.inspect(msg)
    {:noreply, client}
  end
end
