defmodule Starbridge.Server do
  use GenServer
  require Starbridge.Logger, as: Logger

  # association argument is a map of %{channel_name: [{:platform, channel_identifier}]}?
  def register(name, server) do
    Logger.debug(name <> " client registered")

    GenServer.cast(__MODULE__, {:register_client, {name, server}})
  end

  def send_message(platform, channel, content, nick) do
    GenServer.cast(__MODULE__, {:message, {platform, channel, content, nick}})
  end

  def start_link(_) do
    recasts = File.read!(".recast")
    recasts = Starbridge.Util.parse_recast(recasts)

    GenServer.start_link(__MODULE__, %{ recasts: recasts, clients: [] }, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:register_client, {name, server}}, state) do
    registered_client = Map.update(state, :clients, nil, fn clients -> [ {name, server} | clients ] end)
    {:noreply, registered_client}
  end

  @impl true
  def handle_cast({:message, {platform, channel, content, nick}}, state) do
    state.recasts
    |> Map.get({platform, channel})
    |> recast_messages(state.clients, content, nick)

    {:noreply, state}
  end

  def recast_messages(targets, clients, content, nick) do
    all_registered = Enum.flat_map(clients, fn {registered_platform, _} ->
      Enum.map(targets, fn {platform, _} ->
        registered_platform == platform
      end)
    end)
    |> Enum.all?()

    if all_registered do
      Enum.map(targets, fn {platform, channel} ->
        {_, server} = Enum.find(clients, fn {p, _} -> p == platform end)
        GenServer.cast(server, {:send_message, {channel, content, nick}})
      end)
    else
    end
  end
end
