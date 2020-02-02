defmodule ProteinTranslation do

  @doc """
  Allows easier `in` checks in cond.

  # Example
      table_in \"foo\" do
        [\"bar\", \"foo\"] -> true
        [\"test\"] -> false
      end
  """
  defmacro table_in(expr, do: block) do
    update_ins = for n <- Enum.slice(block, 0..-2) do
      items = elem(n, 2)
      quote do
        unquote(expr) in unquote(List.flatten(List.first(items))) -> unquote(Enum.at(items, 1))
      end
    end
    |> List.flatten
    |> Kernel.++([Enum.at(block, -1)])

    quote do
      cond do
        unquote(update_ins)
      end
    end
  end


  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    rna = rna
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.reduce_while([], fn x, acc ->
      x
      |> Enum.join
      |> of_codon
      |> case do
           {:ok, "STOP"} -> {:halt, acc}
           {:ok, codon} -> {:cont, [codon | acc]}
           {:error, _} -> {:halt, {:error, "invalid RNA"}}
         end
    end)
    case rna do
      {:error, _} -> rna
      _ -> {:ok, Enum.reverse(rna)}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    table_in codon do
      ["UGU", "UGC"] -> {:ok, "Cysteine"}
      ["UUA", "UUG"] -> {:ok, "Leucine"}
      ["AUG"] -> {:ok, "Methionine"}
      ["UUU", "UUC"] -> {:ok, "Phenylalanine"}
      ["UCU", "UCC", "UCA", "UCG"] -> {:ok, "Serine"}
      ["UGG"] -> {:ok, "Tryptophan"}
      ["UAU", "UAC"] -> {:ok, "Tyrosine"}
      ["UAA", "UAG", "UGA"] -> {:ok, "STOP"}
      true -> {:error, "invalid codon"}
    end
  end

end
