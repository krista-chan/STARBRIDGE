defmodule Starbridge.IRC do
  import Starbridge.Env
  alias Starbridge.Server
  require Starbridge.Logger, as: Logger
  use GenServer

  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  def init(client) do
    ExIRC.Client.add_handler client, self()
    ExIRC.Client.connect! client, env(:irc_address), env(:irc_port, :int)

    Server.register(:irc, client)
    {:ok, client}
  end

  @impl true
  def handle_info({:connected, _, _}, client) do
    Logger.debug("Connected to IRC server")
    ExIRC.Client.logon client, env(:irc_password), "STARBRIDGE", "STARBRIDGE", "*BRIDGE"

    {:noreply, client}
  end

  def handle_info({:received, content, sender_info}, client) do
    Logger.debug("<#{sender_info.nick}> #{content}")
    {:noreply, client}
  end

  def handle_info(:disconnected, client) do
    Logger.debug("Disconnected")
    {:noreply, client}
  end

  def handle_info(:logged_in, client) do
    Logger.debug("Logged in")

    channels = Starbridge.IRC.parse_channels env(:irc_channels)
    Enum.map(channels, fn {channel, pass} -> join_channel(client, channel, pass) end)

    {:noreply, client}
  end

  def handle_info({:joined, channel}, client) do
    Logger.debug("Joined channel #{channel}")
    {:noreply, client}
  end

  def handle_info({:unrecognized, name, msg}, client) do
    Logger.info("#{name}: #{msg.args |> Enum.join(" ")}")
    {:noreply, client}
  end

  def handle_info({:notice, msg, _}, client) do
    Logger.notice("#{msg}")
    {:noreply, client}
  end

  def handle_info({:names_list, channel, names}, client) do
    Logger.debug("#{channel} has users #{names}")
    {:noreply, client}
  end

  def handle_info({:received, msg, info, channel}, client) do
    Logger.debug("<#{info.nick}#{channel} @ #{env(:irc_address)}> #{msg}")
    Server.send_message(:irc, channel, msg, info)
    {:noreply, client}
  end

  def handle_info(msg, client) do
    Logger.debug("Recv unknown message")
    IO.inspect msg
    {:noreply, client}
  end

  def parse_channels(input) do
    input
    |> String.split(",")
    |> Enum.map(fn i -> parse_channel(i) end)
  end

  def parse_channel("#" <> name), do: {"#" <> name, nil}
  def parse_channel("(" <> data) do
    {channel, pass} = String.replace(data, ~r/[()]/, "")
    |> String.split(~r/\s+/)
    |> List.to_tuple

    {channel, pass}
  end

  def join_channel(client, name, nil) do
    ExIRC.Client.join(client, name)
  end

  def join_channel(client, name, pass) do
    ExIRC.Client.join(client, name, pass)
  end
end