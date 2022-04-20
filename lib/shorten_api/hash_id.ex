defmodule ShortenApi.HashId do
  @hash_id_length 8

  @doc "Generates a HashId"
  @spec generate(String.t) :: String.t
  def generate(url) do
    url
    |> (&:crypto.hash(:sha, &1)).()
    |> Base.encode64
    |> binary_part(0, @hash_id_length)
  end
end
