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

      iex> ShortenApi.HashId.generate(:atom)
      :error

      iex> ShortenApi.HashId.generate(nil)
      :error

  """
  @spec generate(String.t() | any()) :: :error | {:ok, String.t()}
  def generate(text) when is_binary(text), do: {:ok, generate!(text)}
  def generate(any), do: generate!(any)

  @doc """
  ## Examples

      iex> ShortenApi.HashId.generate!("ABC")
      "PAG9uybz"

      iex> ShortenApi.HashId.generate!(:atom)
      :error

      iex> ShortenApi.HashId.generate!(nil)
      :error

  """
  @spec generate!(String.t() | any()) :: :error | String.t()
  def generate!(text) when is_binary(text) do
    text
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64()
    |> binary_part(0, @hash_id_length)
  end

  def generate!(_any), do: :error
end
