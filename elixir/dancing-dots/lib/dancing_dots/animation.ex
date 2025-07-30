defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(options :: opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot_obj :: dot, frame :: frame_number, options :: opts) :: dot

  @spec __using__(any) :: Macro.t()
  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation

      @impl DancingDots.Animation
      def init(options), do: {:ok, options}

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  alias DancingDots.Dot

  @impl DancingDots.Animation
  def handle_frame(%Dot{opacity: op} = dot, frame_number, _opts)
      when rem(frame_number, 4) === 0 do
    %Dot{dot | opacity: op / 2}
  end

  @impl DancingDots.Animation
  def handle_frame(dot, _frame_number, _opts), do: dot
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  alias DancingDots.Dot

  @impl DancingDots.Animation
  def init([velocity: velocity] = opts) when is_number(velocity) do
    {:ok, opts}
  end

  @impl DancingDots.Animation
  def init([velocity: velocity]) do
    {:error,
     "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
  end

  @impl DancingDots.Animation
  def init(_) do
    {:error,
     "The :velocity option is required, and its value must be a number. Got: nil"}
  end

  @impl DancingDots.Animation
  def handle_frame(%Dot{radius: rad} = dot, frame_number, velocity: velocity) do
    %Dot{dot | radius: rad + ((frame_number - 1) * velocity)}
  end
end
