defmodule Starbridge.Discord do
  use GenServer
  alias Starbridge.{Env, Server}
  require Starbridge.Logger, as: Logger

  def start_link(client) do
    Starbridge.Discord.Consumer.start_link
    GenServer.start_link(__MODULE__, client, name: __MODULE__)
  end

  @impl true
  def init(client) do
    {:ok, client}
  end

  @impl true
  def handle_cast({:send_message, {serv_name, src_channel, target_channel, content, nick}}, client) do
    Nostrum.Api.create_message(target_channel |> String.to_integer, "<#{nick} #{src_channel} @ #{serv_name}> " <> content)

    {:noreply, client}
  end

  defmodule Consumer do
    use Nostrum.Consumer

    def start_link do
      Consumer.start_link(__MODULE__, name: Nostrum.Consumer)
    end

    @impl true
    def handle_event({:READY, client, _}) do
      Logger.debug("Logged in as #{client.user.username}##{client.user.discriminator} (#{client.user.id})")
      Server.register("discord", Starbridge.Discord)
    end

    def handle_event({:MESSAGE_CREATE, msg, _}) do
      if !msg.author.bot do
        channels = Env.env(:discord_channels)
        |> String.split(",")
        |> Enum.map(fn s -> String.trim(s) |> String.to_integer end)

        if channels |> Enum.member?(msg.channel_id) do
          channel = Nostrum.Api.get_channel!(msg.channel_id)
          guild = Nostrum.Api.get_guild!(msg.guild_id)
          Logger.debug("<#{msg.author.username}##{msg.author.discriminator} in ##{channel.name} @ #{guild.name}> #{msg.content}")
          Server.send_message("discord", guild.name, {"#" <> channel.name, channel.id |> Integer.to_string()}, msg.content, msg.author.username)
        end
      end
    end

    def handle_event(_) do
      :noop
    end
  end
end
