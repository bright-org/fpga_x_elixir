defmodule FpgaExp do
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif(~c'./priv/fpga_exp', 0)
  end

  def fpga_exp_nif(_x) do
    raise "NIF fast_compare/1 not implemented"
  end

  def fpga_exp(x) do
    %{x | data: %{x.data | state: fpga_exp_nif(x.data.state)}}
  end

end
