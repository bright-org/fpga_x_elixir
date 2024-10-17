defmodule NxNifTest do
  use ExUnit.Case
  doctest NxNif

  test "greets the world" do
    assert NxNif.hello() == :world
  end
end
