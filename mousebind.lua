local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.mouse_bindings = {}
end

return module