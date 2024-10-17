# DMA経由で 128bit 幅の fp32 の exp 計算を行う評価環境

## はじめに

メモリ上にある fp32 のベクトルデータに対して DMA で指数計算(exp)を行う評価環境です。

KV260 用と KR260 用を準備中ですが、主に KV260 用に説明しますので、KR260 では随時読み替えてください。


## 事前準備

Vitis 2023.2 などがインストール済みであることを前提としています。

```bash
source /tools/Xilinx/Vitis/2023.2/settings64.sh 
```

などを実行しておいてください。

またサブモジュールを使うので

```bash
git submodule update --init --recursive
```

などを実施して、サブモジュールを展開しておいてください。



## 合成方法

合成は Vivado の動く PC で行います。

kv260/syn/tcl にて

```bash
make
```

と打てば合成され  eval_exp_fp32_128_kv260_tcl.runs/impl_1 に eval_exp_fp32_128_kv260.bit が出来上がります。



## 実行方法

まず `projects/eval_dma_calc/eval_exp_fp32_128/kv260/app` ディレクトリに PC で合成した `eval_exp_fp32_128_kv260.bit` を置いてください。

### Elixir で実行

`projects/eval_dma_calc/eval_exp_fp32_128/kv260/app` ディレクトリに移動し

```bash
make run_elixir
```

と実行すると、DeviceTree Overlay による bitstream のダウンロードやデバイスドライバのロードを行った後に iex を起動します。

続けて、iex で

```
iex> NxNif.calc(1024*1024)
```

等のようにサイズを指定して計算を指示するとサンプルを実行します。

現状メモリ確保が 16バイトアライメントになっていないとデバイスドライバでエラーとなるので、何度か繰り返して運のいいケースを探してください。

また引数は16の倍数になるようにしてください。


### C++ 版の実行

下記のように実行します。

```bash
make run_cpp
```

### Rust 版の実行

下記のように実行します。

```bash
make run_rust
```



## RTL のシミュレーション方法

計算ではなく DMA のテスト用にシミュレーション環境も作っています。

### xsim を使う方法

kv260/sim/tb_top/xsim にて

```bash
make
```

シミュレーション時間が長いです。

### verilator を使う方法

kv260/sim/tb_top/verilator にて

```bash
make
```

Segmentation fault を起こす場合が報告されており、その場合、事項の C++ 版だとうまく行く場合があります。


### verilator を C++言語のテストドライバで使う方法

kv260/sim/tb_top/verilator_cpp にて

```bash
make
```

と実行します。

