local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.launch_menu = {
    {
      label = 'PowerShell',
      args = { 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-NoLogo' },
      domain = { DomainName = 'local' },
    },
  }
end

return module