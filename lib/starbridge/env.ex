defmodule Starbridge.Env do
  def env(key), do: Application.get_env(:starbridge, key)

  def env(key, :int), do: Application.get_env(:starbridge, key) |> to_int
  def env(key, default), do: Application.get_env(:starbridge, key, default)
  def env(key, default, :int), do: Application.get_env(:starbridge, key, default) |> to_int

  defp to_int(val) when is_binary(val), do: String.to_integer(val)
  defp to_int(val) when is_integer(val), do: val
end
