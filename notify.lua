local wezterm = require 'wezterm'
local module = {}
local waiting_panes = {}

function module.is_waiting(pane_id)
  return waiting_panes[pane_id] == true
end

function module.clear_waiting(pane)
  waiting_panes[pane:pane_id()] = nil
end

function module.clear_tab_waiting(tab)
  for _, pane in ipairs(tab:panes()) do
    waiting_panes[pane:pane_id()] = nil
  end
end

function module.apply_to_config(config)
  -- ベル音を無効化（視覚・OS通知に置き換えるため）
  config.audible_bell = 'Disabled'

  -- ベルが鳴ったとき（\a が送られたとき）にOS通知を出す
  wezterm.on('bell', function(window, pane)
    waiting_panes[pane:pane_id()] = true
    local title = pane:tab():get_title()
    window:toast_notification(
      'WezTerm',
      '⚡' .. title,
      nil,  -- URL（不要なのでnil）
      5000  -- 表示時間(ms)
    )
  end)
end

return module
