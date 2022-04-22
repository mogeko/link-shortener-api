defmodule ShortenApi.HashId do
  @moduledoc """
  Handling HashId
  """
  @hash_id_length 8

  @type t :: atom() | nil | String.t()

  @spec generate(t()) :: :error | {:ok, String.t()}
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
  def generate(text) when is_binary(text), do: {:ok, generate!(text)}
  def generate(value), do: generate!(value)

  @doc """
  ## Examples

      iex> ShortenApi.HashId.generate!("ABC")
      "PAG9uybz"

      iex> ShortenApi.HashId.generate!(:atom)
      :error

      iex> ShortenApi.HashId.generate!(nil)
      :error

  """
  @spec generate!(t()) :: :error | String.t()
  def generate!(text) when is_binary(text) do
    text
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64()
    |> binary_part(0, @hash_id_length)
  end

  def generate!(atom) when is_atom(atom), do: :error
  def generate!(nil), do: :error
end
