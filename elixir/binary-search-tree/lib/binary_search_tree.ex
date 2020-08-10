defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(%{data: tr_data, right: nil} = tree, data) when data > tr_data, do: Map.put(tree, :right, new(data))
  def insert(%{data: tr_data, left: nil} = tree, data) when data <= tr_data, do: Map.put(tree, :left, new(data))
  def insert(%{data: tr_data} = tree, data) when data > tr_data, do: Map.put(tree, :right, insert(tree.right, data))
  def insert(%{data: tr_data} = tree, data) when data <= tr_data, do: Map.put(tree, :left, insert(tree.left, data))

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(%{data: data, left: nil, right: nil}), do: [data]
  def in_order(%{data: data, left: nil, right: right}), do: [data] ++ in_order(right)
  def in_order(%{data: data, left: left, right: nil}), do: in_order(left) ++ [data]
  def in_order(tree), do: in_order(tree.left) ++ [tree.data] ++ in_order(tree.right)
end
