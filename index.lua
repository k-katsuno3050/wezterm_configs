-- index.lua
local wezterm = require 'wezterm'
local index = {}

function index.apply()
    local config = wezterm.config_builder()

    -- 各モジュールを呼び出して設定を注入する
    require('basic_config').apply(config)
    require('colors').apply(config)
    require('keybind').apply(config)
    require('launcher').apply(config)
    require('mousebind').apply(config)
    require('tab').apply(config)

    return config
end

return index