defmodule RNATranscription do
  @convert_table %{
    ?C => ?G,
    ?G => ?C,
    ?A => ?U,
    ?T => ?A,
  }
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> Enum.map(fn x ->
      Map.get(@convert_table, x)
    end)
  end
end
