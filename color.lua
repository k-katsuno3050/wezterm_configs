local wezterm = require 'wezterm'
local module = {}

-- WSL / デフォルト用カラー
local wsl_colors = {
  foreground    = "#ffffff",
  background    = "#002e0e",
  cursor_bg     = "#c1d284",
  cursor_fg     = "#1a1a1a",
  cursor_border = "#c1d284",
  selection_fg  = "#1a1a1a",
  selection_bg  = "#b6d156",
  tab_bar = {
    background = "#002e0e",
  },
  scrollbar_thumb = '#b6d156',
  split = '#4a9060',
  ansi = {
    "#000000", -- black
    "#ff5555", -- red
    "#50fa7b", -- green
    "#f1fa8c", -- yellow
    "#aca3ff", -- blue
    "#ff79c6", -- magenta
    "#8be9fd", -- cyan
    "#bfbfbf", -- white
  },
  brights = {
    -- "#4d4d4d", -- bright black
    "#a1a1a1", -- bright black
    "#ff6e67", -- bright red
    "#55e284", -- bright green
    "#f4f99d", -- bright yellow
    "#7597ff", -- bright blue
    "#ff83c9", -- bright magenta
    "#aaefff", -- bright cyan
    "#e6e6e6", -- bright white
  },
}

-- PowerShell 用カラー（青系統一）
local ps_colors = {
  foreground    = "#cce4ff",
  background    = "#01192e",
  cursor_bg     = "#7ec8ff",
  cursor_fg     = "#01192e",
  cursor_border = "#7ec8ff",
  selection_fg  = "#01192e",
  selection_bg  = "#3a9efd",
  tab_bar = {
    background = "#01192e",
  },
  scrollbar_thumb = '#3a9efd',
  split = '#3a6080',
  ansi = {
    "#0a1628", -- black
    "#5577cc", -- red   → 青紫
    "#4da6ff", -- green → 水色
    "#89c4ff", -- yellow → 薄青
    "#1565c0", -- blue  → 濃紺
    "#5b9bd5", -- magenta → スチールブルー
    "#7ec8ff", -- cyan  → 明るい水色
    "#a8c8e8", -- white → 薄青白
  },
  brights = {
    "#1e3a5f", -- bright black
    "#7799ee", -- bright red   → 青紫明
    "#66bbff", -- bright green → 明水色
    "#aad4ff", -- bright yellow → より薄い青
    "#3b78ff", -- bright blue  → 鮮やか青
    "#80b3e0", -- bright magenta → 明スチール
    "#b3e0ff", -- bright cyan  → 淡水色
    "#dceeff", -- bright white → ほぼ白青
  },
}

-- SSH 用カラー（赤系統一）
local ssh_colors = {
  foreground    = "#ffffff",
  background    = "#2e0000",
  cursor_bg     = "#ff8080",
  cursor_fg     = "#2e0000",
  cursor_border = "#ff8080",
  selection_fg  = "#2e0000",
  selection_bg  = "#ff4444",
  tab_bar = {
    background = "#2e0000",
  },
  scrollbar_thumb = '#ff4444',
  split = '#804040',
  ansi = {
    "#1a0000", -- black
    "#ff5555", -- red
    "#ff8866", -- green → オレンジ赤
    "#ffaa88", -- yellow → サーモン
    "#cc3333", -- blue → 深紅
    "#ff6677", -- magenta → ピンク赤
    "#ff9988", -- cyan → 薄オレンジ
    "#e8c0c0", -- white → 薄ピンク白
  },
  brights = {
    "#4d1010", -- bright black
    "#ff7777", -- bright red
    "#ffaa88", -- bright green
    "#ffc4a8", -- bright yellow
    "#ee5555", -- bright blue
    "#ff88aa", -- bright magenta
    "#ffbbaa", -- bright cyan
    "#ffe8e8", -- bright white
  },
}

-- グラデーション定義
local wsl_gradient = {
  orientation = { Linear = { angle = 30.0 } },
  colors = { '#002e0e', '#00424a', '#002e0e' },
  interpolation = 'Linear',
  blend = 'Rgb',
}

local ps_gradient = {
  orientation = { Linear = { angle = 30.0 } },
  colors = { '#01192e', '#28115d', '#01192e' },
  interpolation = 'Linear',
  blend = 'Rgb',
}

local ssh_gradient = {
  orientation = { Linear = { angle = 30.0 } },
  colors = { '#2e0000', '#54270a', '#2e0000' },
  interpolation = 'Linear',
  blend = 'Rgb',
}

function module.apply_to_config(config)
  -- デフォルトは WSL カラーを適用
  config.colors = wsl_colors
  config.window_background_gradient = wsl_gradient

  wezterm.on('update-right-status', function(window, pane)
    local domain = (pane:get_domain_name() or '')
    local is_ssh = (pane:get_user_vars().IS_SSH or '0') == '1'
    local proc = (pane:get_foreground_process_name() or ''):lower()
    local title = (pane:get_title() or ''):lower()
    local is_ssh_proc = proc:find('ssh') ~= nil
    -- タイトルに「@ip-xx-xx」や「@xxx.xxx.xxx」形式のIPが含まれればSSH判定
    local is_ssh_title = title:find('@ip%-') ~= nil or title:find('@%d+%.%d+') ~= nil

    if is_ssh or is_ssh_proc or is_ssh_title then
      window:set_config_overrides({ colors = ssh_colors, window_background_gradient = ssh_gradient })
    elseif domain == 'local' then
      window:set_config_overrides({ colors = ps_colors, window_background_gradient = ps_gradient })
    else
      window:set_config_overrides({ colors = wsl_colors, window_background_gradient = wsl_gradient })
    end
  end)
end

return module