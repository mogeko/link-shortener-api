defmodule ShortenApi.DB.LinkTest do
  use ExUnit.Case, async: true

  alias ShortenApi.DB.Link
  import Ecto.Changeset, only: [change: 2]

  @example_url "https://www.example.com"
  @example_hash "dA5zl5B8"

  setup_all do
    schema = %Link{}
    changeset = change(schema, %{hash: @example_hash, url: @example_url})
    {:ok, schema: schema, changeset: changeset}
  end

  test "pass all checks", %{schema: schema} do
    changeset = Link.changeset(schema, %{hash: @example_hash, url: @example_url})

    assert changeset.valid?
  end

  test "more complex url", %{schema: schema} do
    url = "http://www.example.com?user=mogeko&email=mogeko@example.com"
    changeset = Link.changeset(schema, %{hash: "lnI0HDUo", url: url})

    assert changeset.valid?
  end

  test "if hash is empty", %{schema: schema} do
    changeset = Link.changeset(schema, %{url: @example_url})

    assert !changeset.valid?
    assert changeset.errors[:hash] == {"does not match target link", []}
  end

  test "hash should be matched with hash of url", %{changeset: changeset} do
    changeset = Link.validate_hash_matched(changeset, :hash, :url)

    assert changeset.valid?
  end
end
