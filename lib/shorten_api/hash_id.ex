defmodule ShortenApi.HashId do
  @moduledoc """
  Handling HashId
  """
  @hash_id_length 8

  @doc """
  Generates a HashId

  ## Examples

      iex> ShortenApi.HashId.generate("ABC")
      {:ok, "PAG9uybz"}

  """
  @spec generate(String.t) :: :error | {:ok, String.t}
  def generate(text), do: {:ok, generate!(text)}

  @doc """
  ## Examples

      iex> ShortenApi.HashId.generate!("ABC")
      "PAG9uybz"

  """
  @spec generate!(String.t) :: String.t
  def generate!(text) do
    text
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64()
    |> binary_part(0, @hash_id_length)
  end
end
