local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.launch_menu = {
    {
      label = 'New Tab - WSL (Ubuntu)',
      args = { 'zsh', '--login' },
      domain = { DomainName = 'WSL:Ubuntu-22.04' },
    },
    -- 【ローカル】
    {
      label = 'New Tab - PowerShell',
      args = { 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-NoLogo' },
      domain = { DomainName = 'local' },
    },
    -- 【SSH】
    {
      label = 'SSH to AWS',
      args = { 'ssh', 'ec2-user@aws' },
      domain = { DomainName = 'WSL:Ubuntu-22.04' },
    },
  }
end

return module