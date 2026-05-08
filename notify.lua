local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  -- ベル音を無効化（視覚・OS通知に置き換えるため）
  config.audible_bell = 'Disabled'

  -- ベルが鳴ったとき（\a が送られたとき）にOS通知を出す
  wezterm.on('bell', function(window, pane)
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
