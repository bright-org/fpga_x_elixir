# DMA経由で 128bit 幅の fp32 の exp 計算を行う評価環境

## はじめに

メモリ上にある fp32 のベクトルデータに対して DMA で指数計算(exp)を行う評価環境です。

## PCでの論理合成



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

