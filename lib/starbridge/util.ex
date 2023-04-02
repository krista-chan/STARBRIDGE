defmodule Starbridge.Util do

  def parse_recast(input) do
    input
    |> String.trim()
    |> String.split(~r/(\n|\r\n)/)
    |> Enum.flat_map(fn i ->
      {lhs, arrow, rhs} = parse_one_recast(i)
      case arrow do
        :unidirectional -> [{lhs, rhs}]
        :bidirectional -> [{lhs, rhs}, {rhs, lhs}]
      end
    end)
    |> Enum.group_by(
      fn {{platform, _}, _} -> platform end,
      fn {{_, src_channel}, rhs} -> {src_channel, rhs} end
      )
    |> Enum.map(
      fn {p, channels} ->
        Enum.group_by(
          channels,
          fn {c, _} -> {p, c} end,
          fn {_, r} -> r end
        )
      end)
    |> Enum.reduce(fn e, acc -> Map.merge(e, acc) end)
  end

  defp parse_one_recast(input) do
    [lhs, arrow, rhs] = input
    |> String.split(~r/\s+/)

    arrow = parse_arrow(arrow)
    [lhs, rhs] = parse_platform_channel_pair([lhs, rhs])

    {lhs, arrow, rhs}
  end

  defp parse_arrow("<->"), do: :bidirectional

  defp parse_arrow("->"), do: :unidirectional

  defp parse_platform_channel_pair(input) when is_binary(input) do
    [plat, chan] = input
    |> String.split(":")

    if plat == "irc" do
      Starbridge.Util.IRC.parse_channel(chan)
    else
      chan
    end

    {plat, chan}
  end

  defp parse_platform_channel_pair(input) when is_list(input) do
    Enum.map(input, &parse_platform_channel_pair/1)
  end

  defmodule IRC do
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
  end
end
