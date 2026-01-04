# 🧭 RubyPyMill Coding Style Guide（pathlib 編）

RubyPyMill および PoC 実行ノートブックでは、**OS に依存しない堅牢なパス操作**を実現するため、すべてのファイルパスは `pathlib` モジュールを用いて統一的に扱います。

---

## 📂 1. 基本方針

| 項目           | 方針                                              | 例                                             |
| ------------ | ----------------------------------------------- | --------------------------------------------- |
| ベースディレクトリの宣言 | 文字列ではなく、`Path()` で明示的に初期化                       | `DATA_DIR = Path("C:/project/data")`          |
| パス結合         | `/` 演算子で統一（`os.path.join`禁止）                    | `csv_path = DATA_DIR / "input.csv"`           |
| ディレクトリ作成     | `.mkdir(parents=True, exist_ok=True)`           | `SAVE_DIR.mkdir(parents=True, exist_ok=True)` |
| JSON 読み込みパス  | 読み込み直後に `Path()` へ変換                            | `DOCX_PATH = Path(params["DOCX_PATH"])`       |
| ファイル出力       | `Path` オブジェクトをそのまま `to_csv()` や `savefig()` に渡す | `df.to_csv(SAVE_DIR / "result.csv")`          |

---

## 🥫 2. 初期化テンプレート（推奨パターン）

```python
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# === ベースディレクトリ ===
DATA_DIR = Path("C:/Users/h_ino/Code/DevLab/project/kodama-poc/datas/kodama-casting-datas/")
OUTPUT_DIR = Path("C:/Users/h_ino/Code/DevLab/project/kodama-poc/outputs/figs/")
DOCX_PATH = Path("C:/Users/h_ino/Code/DevLab/project/kodama-poc/datas/templates/20251021_種別不具合詳細表・A4横（Libreテンプレート）.docx")

# === 出力ディレクトリ構成 ===
SAVE_DIR = OUTPUT_DIR / "analysis"
SAVE_DIR.mkdir(parents=True, exist_ok=True)

# === ファイルの結合 ===
csv_path = DATA_DIR / "20250922_鋼造部労務年数(経験年数)早見表.csv"
df = pd.read_csv(csv_path)

# === グラフ保存 ===
fig, ax = plt.subplots()
df["勤続年数"].plot.hist(ax=ax)
plt.savefig(SAVE_DIR / "fig_勤続年数分布.png", dpi=300, bbox_inches="tight")
print("✅ 保存:", SAVE_DIR / "fig_勤続年数分布.png")
```

---

## 🤖 3. JSON パラメータとの連携

RubyPyMill では、`kodama-casting.json` のような外部設定ファイルでディレクトリやテンプレートを指定することがあります。

その場合、JSON 読み込み後にすぐ `Path()` へ変換するのが安全です：

```python
import json
from pathlib import Path

with open("project/kodama-poc/params/kodama-casting.json", encoding="utf-8") as f:
    params = json.load(f)

DATA_DIR  = Path(params["DATA_DIR"])
OUTPUT_DIR = Path(params["OUTPUT_DIR"])
DOCX_PATH  = Path(params["DOCX_PATH"])
```

これにより、後続の `/` 演算すべてが OS に依存せず正常に動作します。

---

## 🦤 4. トラブルを防ぐためのポイント

| よくある落とし穴                        | 回避方法                                        |
| ------------------------------- | ------------------------------------------- |
| JSON の値が文字列のまま                  | `Path()` で即変換する                             |
| `os.path.join()` を混在使用          | `/` に統一する                                   |
| ディレクトリが存在せず `FileNotFoundError` | `.mkdir(parents=True, exist_ok=True)` で事前作成 |
| Windows でバックスラッシュが混じる           | `Path` オブジェクトで自動解決（心配不要）                    |

---

## 🧠 5. 実行出力例（Windows 環境）

```
✅ 保存: C:\Users\h_ino\Code\DevLab\project\kodama-poc\outputs\figs\analysis\fig_勤続年数分布.png
```

---

## 💎 6. Style Summary Table

| Rule               | Description          | Benefit   |
| ------------------ | -------------------- | --------- |
| **Path化の徹底**       | 文字列をすぐに `Path()` で統一 | OS間の互換性確保 |
| **`/` で結合**        | 可読性と保守性が向上           | join構文不要  |
| **`mkdir()` で準備**  | 出力先ディレクトリを自動生成       | 実行エラー防止   |
| **JSON後即Path化**    | 型不一致エラーを回避           | 外部設定の安定運用 |
| **ファイル出力はPathのまま** | 文字列変換不要              | 簡潔・堅牢     |

---

💬 **結論：**

> RubyPyMill のすべてのノートブック・スクリプトは
> `pathlib` ベースで書かれるべき。
> それが PoC 自動化と OSS 連携の「美しい実装作法」です。 🌿
