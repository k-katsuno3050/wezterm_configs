local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.mouse_bindings = {
    -- 右クリックでクリップボードから貼り付け
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom 'Clipboard',
    },
  }
end

return module