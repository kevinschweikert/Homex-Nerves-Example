defmodule HomexDemoTest do
  use ExUnit.Case
  doctest HomexDemo

  test "greets the world" do
    assert HomexDemo.hello() == :world
  end
end
