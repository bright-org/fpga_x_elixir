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
    # 乱数生成
    key = Nx.Random.key(123)
    {x, _} = Nx.Random.normal(key, shape: {n}, names: [:x], type: {:f, 32})

    # CPU で計算
    start_time = System.monotonic_time()
    y_cpu = Nx.exp(x)
    end_time = System.monotonic_time()
    duration = System.convert_time_unit(end_time - start_time, :native, :microsecond)
    IO.puts("CPU 計算時間  : #{duration} us")
#   IO.inspect(y_cpu)

    # FPGA で計算
    start_time = System.monotonic_time()
    y_fpga = FpgaExp.fpga_exp(x)
    end_time = System.monotonic_time()
    duration = System.convert_time_unit(end_time - start_time, :native, :microsecond)
    IO.puts("FPGA 計算時間 : #{duration} us")
#   IO.inspect(y_fpga)

    # 結果検証
    diff =
      Nx.subtract(y_cpu, y_fpga)
      |> Nx.abs()
      |> Nx.reduce_max()
      |> Nx.to_number()
    IO.puts("最大誤差：#{diff}")
  end
end
