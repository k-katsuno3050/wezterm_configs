-- index.lua
local wezterm = require 'wezterm'
local index = {}

function index.apply()
    local config = wezterm.config_builder()

    -- 各モジュールを呼び出して設定を注入する
    require('basic_config').apply_to_config(config)
    require('color').apply_to_config(config)
    require('keybind').apply_to_config(config)
    require('launcher').apply_to_config(config)
    require('mousebind').apply_to_config(config)
    require('tab').apply_to_config(config)

    return config
end

return index