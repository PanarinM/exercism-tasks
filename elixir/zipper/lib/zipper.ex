defmodule Zipper do
  @type t :: %Zipper{
    focus: any,
    left: BinTree.t() | nil,
    right: BinTree.t() | nil,
    head: BinTree.t() | nil,
    story: list(atom)
  }
  @enforce_keys [:focus]
  defstruct [:focus, :left, :right, :head, story: []]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{head: nil, focus: bin_tree.value, left: bin_tree.left, right: bin_tree.right}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{story: story} = zipper) when story === [] do
    %BinTree{value: zipper.focus, left: zipper.left, right: zipper.right}
  end

  def to_tree(zipper) do
    zipper
    |> up
    |> to_tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper), do: zipper.focus

  @spec move(Zipper.t(), atom) :: Zipper.t() | nil
  defp move(zipper, :left) do
    %Zipper{
      focus: Map.get(zipper, :left).value,
      head: %BinTree{value: zipper.focus, right: zipper.right, left: zipper.head},
      left: Map.get(zipper, :left).left,
      right: Map.get(zipper, :left).right,
      story: [:left | zipper.story]
    }
  end
  defp move(zipper, :right) do
    %Zipper{
      focus: Map.get(zipper, :right).value,
      head: %BinTree{value: zipper.focus, left: zipper.left, right: zipper.head},
      left: Map.get(zipper, :right).left,
      right: Map.get(zipper, :right).right,
      story: [:right | zipper.story]
    }
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{left: left}) when left == nil, do: nil
  def left(zipper) do
    zipper
    |> move(:left)
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{right: right}) when right == nil, do: nil
  def right(zipper) do
    zipper
    |> move(:right)
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{story: story}) when story === [], do: nil

  def up(zipper) do
    [direction | story] = zipper.story
    old_node = Map.put(
      zipper.head,
      direction,
      %BinTree{value: zipper.focus, left: zipper.left, right: zipper.right}
    )
    %Zipper{
      focus: zipper.head.value,
      head: Map.get(zipper.head, direction),
      story: story,
      right: old_node.right,
      left: old_node.left,
    }
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    Map.put(zipper, :focus, value)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    Map.put(zipper, :left, left)
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    Map.put(zipper, :right, right)
  end
end
