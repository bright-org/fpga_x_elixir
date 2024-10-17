defmodule NxNif do
  @moduledoc """
  Documentation for `NxNif`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NxNif.hello()
      :world

  """
  def hello do
    :world
  end

  def calc(n) do
    key = Nx.Random.key(123)
    {x, _} = Nx.Random.uniform(key, 0.5, 1.5, shape: {n}, names: [:x], type: {:f, 32})

    start_time = System.monotonic_time()
    y = Nx.exp(x)
    end_time = System.monotonic_time()
    duration = System.convert_time_unit(end_time - start_time, :native, :millisecond)
    IO.puts("CPU 計算時間: #{duration} ms")
    IO.inspect(y)

    start_time = System.monotonic_time()
    y = FpgaExp.fpga_exp(x)
    end_time = System.monotonic_time()
    duration = System.convert_time_unit(end_time - start_time, :native, :millisecond)
    IO.puts("FPGA 計算時間: #{duration} ms")
    IO.inspect(y)
  end
end
