defmodule ShortenApiTest do
  use ExUnit.Case
  doctest ShortenApi

  test "greets the world" do
    assert ShortenApi.hello() == :world
  end
end
