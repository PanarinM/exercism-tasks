defmodule Secrets do
  use Bitwise

  @spec secret_add(number) :: (number -> number)
  def secret_add(secret) do
    fn x -> x + secret end
  end

  @spec secret_subtract(number) :: (number -> number)
  def secret_subtract(secret) do
    fn x -> x - secret end
  end

  @spec secret_multiply(number) :: (number -> number)
  def secret_multiply(secret) do
    fn x -> x * secret end
  end

  @spec secret_divide(number) :: (number -> number)
  def secret_divide(secret) do
    fn x -> div(x, secret) end
  end

  @spec secret_and(number) :: (integer -> integer)
  def secret_and(secret) do
    fn x -> band(x, secret) end
  end

  @spec secret_xor(number) :: (integer -> integer)
  def secret_xor(secret) do
    fn x -> bxor(x, secret) end
  end

  @spec secret_combine((number -> number), (number -> number)) :: (number -> number)
  def secret_combine(secret_function1, secret_function2) do
    fn x -> x |> secret_function1.() |> secret_function2.() end
  end
end
