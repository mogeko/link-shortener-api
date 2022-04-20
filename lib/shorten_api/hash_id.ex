defmodule ShortenApi.HashId do
  @hash_id_length 8

  @doc """
  Generates a HashId

  ## Example
      iex> ShortenApi.HashId.generate({:ok, "ABC"})
      {:ok, "PAG9uybz"}
      iex> ShortenApi.HashId.generate(:error)
      :error

  """
  @spec generate(:error | {:ok, any}) :: :error | {:ok, String.t}
  def generate({:ok, url}) do
    hash_id = url
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64
    |> binary_part(0, @hash_id_length)
    {:ok, hash_id}
  end

  def generate(:error), do: :error
end
