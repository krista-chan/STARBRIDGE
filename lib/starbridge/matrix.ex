defmodule Starbridge.Matrix do
  alias Starbridge.Server
  require Starbridge.Logger, as: Logger
  use GenServer

  def start_link(pid) do
    client = Polyjuice.Client.get_client(pid)
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  def init(client) do
    Server.register(:matrix, client)
    {:ok, client}
  end

  @impl true
  def handle_info(msg, client) do
    IO.inspect(msg)
    {:noreply, client}
  end

  # receive do
  #   {:polyjuice_client, :message, {room_id, %{"content" => %{"msgtype" => "m.text"} = content}}} ->
  #     Logger.debug(content)
  # end
end
