import Config
import Dotenvy

source!([".env", System.get_env()])

config :nostrum,
  token: env!("DISCORD_TOKEN", :string),
  gateway_intents: [
    :guild_messages,
    :message_content,
  ]

config :starbridge,
  irc_channels: env!("IRC_CHANNELS", :string!),
  irc_address: env!("IRC_ADDRESS", :string!),
  irc_password: env!("IRC_PASSWORD", :string, ""), # complains when nil, error in ExIRC
  irc_port: env!("IRC_PORT", :integer, 6667),
  discord_channels: env!("DISCORD_CHANNELS", :string),
  matrix_address: env!("MATRIX_ADDRESS", :string)
