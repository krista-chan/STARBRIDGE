defmodule StarbridgeTest do
  use ExUnit.Case
  doctest Starbridge

  test "greets the world" do
    assert Starbridge.hello() == :world
  end
end
