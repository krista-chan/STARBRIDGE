<div align="center">
  <img src="assets/starbridge_2048w.png" width="256">
</div>

<p style="font-weight: lighter; letter-spacing: .01rem">/stɑɹbɹɪd͡ʒ/</p>

---

## Usage

1. Create and then populate the `.env` with relevant keys and values detailed in the [`default.env`](default.env)

### .env information

The `DISPLAY_STRING` variable represents how messages are sent by all *BRIDGE clients

Variable names

- `$author`: the nickname of the sender of the message
- `$channel`: the channel the message originated from
- `$content`: the actual contents of the message
- `$server`: the server the message originated from

An example display string can be found below

`<$author $channel @ $server> $content`

This is also the default display string

The `DISCORD_STATUS_TYPE` variable represents how the `DISCORD_STATUS` variable is displayed on the discord client

Possible values

- `playing`
- `streaming`
- `listening`
- `watching`

The default value is `playing`

2. Create a `.recast` file

The contents of this file describe relationships between different channels

An example of the syntax can be found below

```
platform:channel_identifier <-> platform:channel_identifier
platform:channel_identifier  -> platform:channel_identifier
```

Currently implemented platforms
- `discord`
- `irc`

The operators `->` and `<->` signify a link between the left hand side and right hand side channels

`lhs -> rhs` represents a unidirectional link, meaning messages from `lhs` are sent to `rhs`, but not the other way round

`lhs <-> rhs` represents a bidirectional link, meaning messages sent in either channel are sent to the other

3. Run the following to launch all clients marked as `*_ENABLED` in the `.env`

```_
iex -S mix
```
