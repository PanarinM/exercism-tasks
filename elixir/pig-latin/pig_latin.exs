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
  @vowel_re ~r/^(a|e|i|o|u|xr|yt)+/
  @consonant_re ~r/^(qu|b|c|d|f|g|h|j|k|l|m|n|p|r|s|t|q|v|w|x|y|z)+/

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end

  def translate_word(word) do
    cond do
      Regex.match?(@vowel_re, word) -> resolve_wovel(word)
      true ->
        case start_consonant?(word) do
          {:ok, cons} -> resolve_consonant(word, cons)
          _ -> raise "Something went wrong"
        end
    end
  end

  def start_consonant?(phrase) do
    case Regex.run(@consonant_re, phrase) do
      [head | _] -> {:ok, head}
      _ -> {:error, 0}
    end
  end

  def resolve_wovel(phrase) do
    phrase <> "ay"
  end

  def resolve_consonant(phrase, cons) do
    cond do
	    String.starts_with?(cons, ["x", "y"]) and String.length(cons) > 1 -> resolve_wovel(phrase)
      true -> String.slice(phrase, String.length(cons)..-1) <> cons <> "ay"
    end
  end

end
