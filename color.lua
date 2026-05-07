local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  -- config.color_scheme = 'Catppuccin Macchiato'
  
  config.colors = {
  -- 1. 基本の背景と文字
  foreground    = "#ffffff", -- 全体の文字色
  background    = "#002e0e", -- 全体の背景色
  cursor_bg     = "#c1d284", -- カーソルの色
  cursor_fg     = "#1a1a1a", -- カーソルが重なった時の文字色
  cursor_border = "#c1d284", -- カーソルの枠線

  -- 2. 選択範囲（マウスでなぞった時）
  selection_fg = "#1a1a1a",    -- noneにすると元の文字色を維持
  selection_bg = "#b6d156", 

  -- 3. タブバー全体の背景（タブがない余白部分）
  tab_bar = {
    background = "#002e0e",
  },

  scrollbar_thumb = '#b6d156',

  -- 4. ANSIカラー（ターミナル内の標準的な8色+明るい8色）
  -- lsコマンドやディレクトリ、プログラムの出力色に影響します
  ansi = {
    "#000000", -- black
    "#ff5555", -- red
    "#50fa7b", -- green
    "#f1fa8c", -- yellow
    "#422ff0", -- blue
    "#ff79c6", -- magenta
    "#8be9fd", -- cyan
    "#bfbfbf", -- white
  },
  brights = {
    "#4d4d4d", -- bright black
    "#ff6e67", -- bright red
    "#55e284", -- bright green
    "#f4f99d", -- bright yellow
    "#7597ff", -- bright blue
    "#ff83c9", -- bright magenta
    "#aaefff", -- bright cyan
    "#e6e6e6", -- bright white
  },
}
end

return module