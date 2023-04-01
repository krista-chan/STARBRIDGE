defmodule Starbridge.Server do
  use GenServer
  import Starbridge.Env
  require Starbridge.Logger, as: Logger

  # association argument is a map of %{channel_name: [{:platform, channel_identifier}]}?
  def register(name, server) do
    Logger.debug(Atom.to_string(name) <> " client registered")

    GenServer.cast(__MODULE__, {:register_client, %{name: name, server: server}})
  end

  def send_message(platform, channel, content, info) do
    GenServer.cast(__MODULE__, {:message, {platform, channel, content, info}})
  end

  def start_link(_) do
    # map of %{{atom, string} => [{atom, string}]}
    # key: {:platform, channel_ident}
    # val: [typeof key]

    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:register_client, %{name: name, server: server}}, state) do
    updated_stuff = state
    |> Map.put(name, server)
    |> Map.put(:recasts, %{{:irc, "#gen"} => [{:irc, "#foxes"}, {:discord, ""}]})
    {:noreply, updated_stuff}
  end

  @impl true
  def handle_cast({:message, {platform, channel, content, info}}, state) do
    # --- test code do not use
    recast = state.recasts[{platform, channel}][:irc]
    GenServer.cast(Starbridge.IRC, {:send_message, {recast, "<#{info.nick}#{channel}> " <> content}})

    {:noreply, state}
  end

  def load_recasts do
    {:ok, irc_recast} = Jason.decode(env(:irc_recast))

    irc_recast
  end
end
