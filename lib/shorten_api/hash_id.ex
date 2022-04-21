defmodule ShortenApi.HashId do
  @moduledoc """
  Handling HashId
  """
  @hash_id_length 8

  @doc """
  Generates a HashId

  ## Examples

      iex> ShortenApi.HashId.generate({:ok, "ABC"})
      {:ok, "PAG9uybz"}

      iex> ShortenApi.HashId.generate(:error)
      :error

  """
  @spec generate(:error | {:ok, String.t()}) :: :error | {:ok, String.t()}
  def generate({:ok, _} = context), do: {:ok, generate!(context)}
  def generate(:error), do: generate!(:error)

  @doc """
  ## Examples

      iex> ShortenApi.HashId.generate!({:ok, "ABC"})
      "PAG9uybz"

      iex> ShortenApi.HashId.generate!(:error)
      :error

  """
  @spec generate!(:error | {:ok, String.t()}) :: :error | String.t()
  def generate!({:ok, url}) do
    url
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64()
    |> binary_part(0, @hash_id_length)
  end

  def generate!(:error), do: :error
end
