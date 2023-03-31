defmodule Starbridge.Logger do
  require Logger

  def log(level, provider, message) do
    Logger.log(level, provider <> " " <> message)
  end

  # ---

  defmacro debug(message) do
    quote do
      {caller_mod, _calling_func, _calling_func_arity, [file: _file, line: _line]} =
        Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.fetch!(1)

      caller_mod =
        caller_mod
        |> Atom.to_string()
        |> String.split(".")
        |> Enum.at(-1)

      provider = "\t[*BRIDGE : #{caller_mod}]"
      Starbridge.Logger.log(:debug, provider, unquote(message))
    end
  end

  defmacro info(message) do
    quote do
      {caller_mod, _calling_func, _calling_func_arity, [file: _file, line: _line]} =
        Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.fetch!(1)

      caller_mod =
        caller_mod
        |> Atom.to_string()
        |> String.split(".")
        |> Enum.at(-1)

      provider = "\t[*BRIDGE : #{caller_mod}]"
      Starbridge.Logger.log(:info, provider, unquote(message))
    end
  end

  defmacro warn(message) do
    quote do
      {caller_mod, _calling_func, _calling_func_arity, [file: _file, line: _line]} =
        Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.fetch!(1)

      caller_mod =
        caller_mod
        |> Atom.to_string()
        |> String.split(".")
        |> Enum.at(-1)

      provider = "\t[*BRIDGE : #{caller_mod}]"
      Starbridge.Logger.log(:warn, provider, unquote(message))
    end
  end

  defmacro error(message) do
    quote do
      {caller_mod, _calling_func, _calling_func_arity, [file: _file, line: _line]} =
        Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.fetch!(1)

      caller_mod =
        caller_mod
        |> Atom.to_string()
        |> String.split(".")
        |> Enum.at(-1)

      provider = "\t[*BRIDGE : #{caller_mod}]"
      Starbridge.Logger.log(:error, provider, unquote(message))
    end
  end

  defmacro notice(message) do
    quote do
      {caller_mod, _calling_func, _calling_func_arity, [file: _file, line: _line]} =
        Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.fetch!(1)

      caller_mod =
        caller_mod
        |> Atom.to_string()
        |> String.split(".")
        |> Enum.at(-1)

      provider = "\t[*BRIDGE : #{caller_mod}]"
      Starbridge.Logger.log(:notice, provider, unquote(message))
    end
  end
end
