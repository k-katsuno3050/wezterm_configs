# WezTerm 設定

WezTerm の設定をモジュール分割して管理するリポジトリです。

## ファイル構成

| ファイル | 説明 |
|---|---|
| `index.lua` | エントリポイント。各モジュールをまとめて設定を返す |
| `basic_config.lua` | フォント・タブバー・IME などの基本設定 |
| `color.lua` | カラースキーム・ANSIカラーなどの色設定 |
| `keybind.lua` | キーバインド設定 |
| `launcher.lua` | ランチャーメニューの設定 |
| `mousebind.lua` | マウスバインド設定 |
| `tab.lua` | タブタイトルの表示フォーマット設定 |

## セットアップ

1. このリポジトリを任意のディレクトリにクローンする
2. ホームディレクトリの `.wezterm.lua` から `index.lua` を呼び出す

```lua
-- ~/.wezterm.lua
local index = require('/path/to/wezterm/index')
return index.apply()
```

## キーバインド一覧

| キー | 動作 |
|---|---|
| `Ctrl+Shift+P` | 新しいタブで PowerShell を開く |
| `Ctrl+Shift+H` | ペインを水平分割（左右） |
| `Ctrl+Shift+V` | ペインを垂直分割（上下） |
| `Ctrl+Shift+R` | 現在のタブをリネームする |
| `Ctrl+Shift+N` | 新しいタブで WSL (Ubuntu-22.04) を開く |
| `Ctrl+Shift+D` | WSL の3ペイン分割プリセット（左1・右上下2） |
| `Ctrl+Shift+h` | 左のペインに移動 |
| `Ctrl+Shift+l` | 右のペインに移動 |
| `Ctrl+Shift+k` | 上のペインに移動 |
| `Ctrl+Shift+j` | 下のペインに移動 |
| `Ctrl+Alt+D` | デバッグオーバーレイを表示 |

## カスタマイズ

各モジュールを個別に編集することで設定を変更できます。

- 色を変えたい場合 → `color.lua`
- キーバインドを追加・変更したい場合 → `keybind.lua`
- フォントやタブの見た目を変えたい場合 → `basic_config.lua`
- WSL のディストリビューション名を変えたい場合 → `basic_config.lua` の `default_domain` と `keybind.lua` 内の `DomainName` を変更する
