defmodule ShortenApi.DB.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "link" do
    field :hash, :string
    field :url, :string
  end

  @spec changeset(Ecto.Schema.t | map, map) :: Ecto.Changeset.t
  def changeset(struct, params) do
    struct
    |> cast(params, [:hash, :url])
    |> validate_required([:hash, :url])
    |> validate_format(:url, ~r/htt(p|ps):\/\/(\w+.)+/)
    |> validate_hash_matched(:hash, :url)
  end

  @doc """
  Check if the `:hash` matches the hash of the `:text`.

  ## Options

  * `:hash` - the hash value, it will be used to match the hash of the `:text`
  * `:text` - its hash should be equal with `:hash`

  ## Examples

      validate_hash_matched(changeset, :hash, :url)

  """
  @spec validate_hash_matched(Ecto.Changeset.t, atom, atom) :: Ecto.Changeset.t
  def validate_hash_matched(changeset, hash, text) do
    import ShortenApi.HashId
    target_hash = get_field(changeset, hash)
    target_text = get_field(changeset, text)

    if generate!({:ok, target_text}) != target_hash do
      add_error(changeset,:hash, "does not match target link")
    else
      changeset
    end
  end
end
