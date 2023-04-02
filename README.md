<div align="center">
  <img src="assets/starbridge_2048w.png" width="256">
</div>

<p style="font-weight: lighter; letter-spacing: .01rem">/stɑɹbɹɪd͡ʒ/</p>

---

## Usage

1. Create and then populate the `.env` with relevant information detailed in the [`default.env`](default.env)

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
