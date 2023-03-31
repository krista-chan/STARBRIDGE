defmodule Starbridge.Server do
  use GenServer
  require Starbridge.Logger, as: Logger

  # association argument is a map of %{channel_name: [{:platform, channel_identifier}]}?
  def register(name, client) do
    Logger.debug(Atom.to_string(name) <> " client registered")

    GenServer.cast(__MODULE__, {:register_client, %{name: name, client: client}})
  end

  def send_message(platform, channel, content, info) do
    GenServer.cast(__MODULE__, {:message, {platform, channel, content, info}})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:register_client, %{name: name, client: client}}, state) do
    {:noreply, Map.put(state, name, client)}
  end

  @impl true
  def handle_cast({:message, {_platform, _channel, _content, _info}}, state) do
    # IO.inspect({platform, content})
    {:noreply, state}
  end
end
