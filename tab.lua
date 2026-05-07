local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
    wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_title
    if not title or #title == 0 then title = tab.active_pane.title end

    -- 【修正ポイント】
    -- max_width を無視して、config.tab_max_width (25) に基づいて判定する
    -- 25文字（半角）以内なら何もしない、超えたら 22文字まで削って '..' を足す
    local limit = config.tab_max_width - 3
    if #title > limit then
      title = wezterm.truncate_right(title, limit - 2) .. '..'
    end

    local bg = "#555555"
    local fg = "#ffffff"
    local edge_color = "#002e0e"

    if tab.is_active then
      bg = "#aed130"
      fg = "#2c2c2c"
    elseif hover then
      bg = "#7c9523"
    end

    return {
      { Background = { Color = edge_color } },
      { Foreground = { Color = bg } },
      { Text = '' },
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = title }, -- ここにスペースを入れない（パーツで余裕を作っているため）
      { Background = { Color = edge_color } },
      { Foreground = { Color = bg } },
      { Text = '' },
      { Text = ' ' },
    }
  end)
end

return module