# RubyPyMill
Running Notebooks the Ruby Way — RubyPyMill and the Art of PoC Automation

---

## 背景と目的
RubyPyMill は、Ruby から **Papermill（Python Notebook Runner）** を制御して、  
「PoC（概念実証）で生まれた知見を業務システムに橋渡しする」ための  
軽量ランナー／自動化スターターです。

PoC は終わりではなく、組織的な知識循環のはじまり。  
Ruby の表現力と Python の実行力をつなぎ、  
「Ruby らしいかたちで Notebook と協働する」開発サイクルを目指します。

---

## 設計思想 — Ruby 4.0 @30 に寄せて
RubyPyMill は、**Ruby 4.0 の理念である多言語協調**に沿って設計されています。  
Ruby が DSL（制御・記述）を担い、Python が Notebook（実行・計算・可視化）を担う。

Ruby が持つ **「人間の思考に寄り添う記述力」と、Python エコシステムが持つ「強力なデータサイエンス資産」** を、
境界なく活用することを目指しています。

その橋渡しを RubyPyMill が担うことで、  
Ruby の世界から Notebook の再現性をそのまま利用できる環境を実現します。

> "Ruby is about collaboration between people, and between tools."  
> — Yukihiro “Matz” Matsumoto

---

## 概念図
```text
Ruby / CLI / CI
    |
    v
RubyPyMill（制御層）
    |
    v
Papermill（Python 実行）
    |
    v
Jupyter Notebook（PoC 実行環境）

※ Notebook / CSV / 画像などの成果物は各層で共有されます
```

---

## 構成概要
| ディレクトリ | 内容 |
|--------------|------|
| bin/ | CLI（ruby_pymill） |
| lib/ | RubyPyMill 本体 |
| py/ | Python 実行環境（Papermill） |
| examples/ | サンプル Notebook / params / outputs |
| docs/ | 開発用ドキュメント |
| spec/ | RSpec テスト |

---
## Installation
RubyPyMill は RubyGems として配布されています。

```bash
gem install ruby_pymill
```

## セットアップ

### Ruby
```bash
bundle install
```

### Python
```bash
python -m venv .venv

# macOS / Linux
source .venv/bin/activate

# Windows (PowerShell)
.\.venv\Scripts\activate

pip install -r py/requirements.txt
python -m ipykernel install --user --name rpymill
```

---

## 基本的な使い方（CLI）
```bash
bundle exec ruby bin/ruby_pymill exec <input.ipynb>   --output <output.ipynb>   --kernel rpymill   [--params params.json]   [--cell_tags "parameters,setup,graph_view"]
```

---

## Example: lang_radar.ipynb

`examples/notebooks/lang_radar.ipynb` は、  
RubyPyMill の基本的な思想と使い方を示すためのサンプル Notebook です。

この Notebook では以下を行います。

- `parameters`  
  Notebook 実行時に外部 JSON から上書き可能なパラメータ定義
- `setup`  
  ライブラリ読み込みや共通関数定義
- `generate_data`  
  Notebook 内部で完結するデータ生成（CSV 出力）
- `graph_view`  
  レーダーチャートの表示（デバッグ・確認用）
- `graph_output`  
  グラフ画像のファイル出力

### 推奨実行パターン

- 全体実行
```
parameters,setup,generate_data,graph_view,graph_output
```

- 表示のみ（デバッグ用途）
```
parameters,setup,graph_view
```

- 出力のみ
```
parameters,setup,graph_output
```

### JSON パラメータ指定例
### JSON parameter example (preview only)

This example loads parameters from JSON and executes only the graph preview
(`graph_view`) without generating output files.

```bash
bundle exec ruby bin/ruby_pymill exec examples/notebooks/lang_radar.ipynb \
  --output examples/outputs/lang_radar_out.ipynb \
  --params examples/params/lang_radar.json \
  --kernel rpymill \
  --cell_tags "parameters,setup,graph_view"

```

---

## RubyPyMill の役割
RubyPyMill は **Papermill の上位制御層**です。

Notebook を論理的な単位（cell tags）で分割し、  
必要なセルのみを 1 セッションで Papermill に渡すことで、  
再現性と実行効率を両立します。

| 特徴 | 説明 |
|------|------|
| 複数タグ指定 | parameters + setup + graph_view などを柔軟に組み合わせ |
| セッション統合 | カーネルを維持したまま Notebook を実行 |
| PoC 向き設計 | 部分実行と全体実行を両立 |
| Ruby 的制御 | Ruby DSL + JSON による実行制御 |

---

## プログラムからの利用について（実験的）
RubyPyMill は CLI を安定したインターフェースとして設計されています。

内部には `RubyPyMill::API` が存在し、  
Ruby コードから直接 Notebook 実行を呼び出すことも可能です。

ただし、API は将来変更される可能性があるため、  
現時点では **実験的な位置づけ**としています。

---

## ライセンス
MIT License  
© 2025 Hiroshi Inoue / OSS-Vision

---

## 補記
RubyPyMill は OSS-Vision と Ruby コミュニティの協調実験として開発されています。  
PoC と業務の間を自然につなぐための実践的なツールとして、  
現場で育てていくことを意図しています。
