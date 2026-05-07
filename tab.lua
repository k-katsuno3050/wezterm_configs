local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_title
    if not title or #title == 0 then title = tab.active_pane.title end

    local limit = config.tab_max_width - 3
    if #title > limit then
      title = wezterm.truncate_right(title, limit - 2) .. '..'
    end

    local domain = tab.active_pane.domain_name or ''
    local is_ssh = tab.active_pane.title:find('@ip%-') ~= nil
                or tab.active_pane.title:find('@%d+%.%d+') ~= nil

    -- ドメイン別カラー定義
    local active_bg, active_fg, inactive_bg, hover_bg
    if is_ssh then
      active_bg  = "#ff8080"
      active_fg  = "#2c0000"
      inactive_bg = "#3a1a1a"
      hover_bg   = "#cc6060"
    elseif domain == 'local' then
      active_bg  = "#7ec8ff"
      active_fg  = "#01192e"
      inactive_bg = "#1a3050"
      hover_bg   = "#5aa8dd"
    else -- WSL
      active_bg  = "#aed130"
      active_fg  = "#1a2c00"
      inactive_bg = "#2a4a2a"
      hover_bg   = "#7c9523"
    end

    local bg = inactive_bg
    local fg = "#aaaaaa"

    if tab.is_active then
      bg = active_bg
      fg = active_fg
    elseif hover then
      bg = hover_bg
      fg = "#ffffff"
    end

    -- タブバー背景色（ドメイン別）
    local tab_bar_bg
    if is_ssh then
      tab_bar_bg = "#2e0000"
    elseif domain == 'local' then
      tab_bar_bg = "#01192e"
    else
      tab_bar_bg = "#002e0e"
    end

    local edge_r = wezterm.nerdfonts.ple_left_half_circle_thick
    local edge_l = wezterm.nerdfonts.ple_right_half_circle_thick

    return {
      { Background = { Color = tab_bar_bg } },
      { Foreground = { Color = bg } },
      { Text = edge_r },
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = title },
      { Background = { Color = tab_bar_bg } },
      { Foreground = { Color = bg } },
      { Text = edge_l },
    }
  end)
end

return module