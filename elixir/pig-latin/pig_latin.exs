defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @vowels ["a", "e", "i", "o", "u", "xr", "yt"]
  @consonants ["qu", "ch", "squ", "th", "sch", "b", "c", "d", "f", "g", "h",
  "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z", ]

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    cond do
      start_wovel?(phrase) -> phrase <> "ay"
      cons = start_consonant?(phrase) -> move_consonant(phrase, cons)
    end
  end

  defp start_wovel?(phrase) do
    Enum.any?(@vowels, fn vowel ->
      String.starts_with?(phrase, vowel)
    end)
  end

  defp start_consonant?(phrase) do
    Enum.reduce_while(@consonants, List.first(@consonants), fn x, acc ->
      case String.starts_with?(phrase, x) do
        true -> {:halt, x}
        _ -> {:cont, false}
      end
    end)
  end

  defp move_consonant(phrase, cons) do
    String.slice(phrase, String.length(cons)..-1)
    |> Kernel.<>(cons)
    |> Kernel.<>("ay")
  end
end
