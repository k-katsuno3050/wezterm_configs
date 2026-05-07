local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  -- デフォルトの接続先をWSLに設定
  config.default_domain = 'WSL:Ubuntu-22.04' 
  
    -- シンプルなタブバーを使用（色の変化を確実に反映させるため）
  config.use_fancy_tab_bar = false 
  config.tab_max_width = 20  -- 1つのタブの最大文字数を指定
  config.tab_bar_at_bottom = true
  config.font_size = 11.0
  config.font = wezterm.font_with_fallback {
    'JetBrains Mono',      -- 英数字用
    'BIZ UDゴシック',
    'Noto Sans JP',        -- もしインストールしていれば
    'Meiryo',             -- 日本語用（Windows標準）
  }
  config.enable_scroll_bar = true

  config.use_ime = true
  config.inactive_pane_hsb = {            -- 操作していない側の画面を少し暗くして集中
    saturation = 0.9,
    brightness = 0.7,
  }
  config.cursor_blink_rate = 0 -- 点滅を止める（111.0のような数値で速度調整も可能）
  config.show_new_tab_button_in_tab_bar = false -- +ボタンを非表示
  config.unix_domains = {} -- unix mux ドメインを非表示
end

return module