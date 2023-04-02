defmodule Starbridge.Discord do
  use Nostrum.Consumer
  alias Starbridge.{Env, Server}
  require Starbridge.Logger, as: Logger

  def start_link do
    Consumer.start_link(__MODULE__, name: __MODULE__)
  end

  def handle_event({:READY, client, _}) do
    Logger.debug("Logged in as #{client.user.username}##{client.user.discriminator} (#{client.user.id})")
    Server.register("discord", client.user)
  end

  def handle_event({:MESSAGE_CREATE, msg, _}) do
    channels = Env.env(:discord_channels)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    if channels |> Enum.member?(msg.channel_id) do
      channel = Nostrum.Api.get_channel!(msg.channel_id)
      guild = Nostrum.Api.get_guild!(msg.guild_id)
      Logger.debug("<#{msg.author.username}##{msg.author.discriminator} in ##{channel.name} @ #{guild.name}> #{msg.content}")
      Server.send_message(:discord, channel, msg.content, msg)
    end
  end

  def handle_event(_) do
    :noop
  end
end
