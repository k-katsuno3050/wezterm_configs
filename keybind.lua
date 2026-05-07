local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.keys = {
    -- 【タブ操作】
    { key = 'W', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
    { key = 'P', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab { args = { 'powershell.exe' }, domain = { DomainName = 'local' } } },
    { key = 'S', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- 【タブのリネーム】
    {
      key = 'R',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line then window:active_tab():set_title(line) end
        end),
      },
    },

    -- 【新しいWSLタブを開く（アクティブなディレクトリを引き継ぐ）】
    {
      key = 'C',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        domain = { DomainName = 'WSL:Ubuntu-22.04' },
      },
    },

    -- 【新しいWSLタブをホームディレクトリで開く】
    {
      key = 'N',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SpawnCommandInNewTab {
        domain = { DomainName = 'WSL:Ubuntu-22.04' },
        -- cd でホームへ移動してから exec でログインシェルに置き換える
        args = { 'zsh', '-c', 'cd && exec zsh --login' },
      },
    },

    -- 【WSL 3分割プリセット】
    {
      key = 'D',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        local cwd = ""
        local cwd_uri = pane:get_current_working_dir()
        if cwd_uri then cwd = cwd_uri.file_path end
        local domain = 'WSL:Ubuntu-22.04'

        -- 左側に1つ、右側に上下2つのレイアウトを作成
        local tab, left_pane, window = window:mux_window():spawn_tab { cwd = cwd, domain = { DomainName = domain } }
        local right_pane_top = left_pane:split { direction = 'Right', cwd = cwd, domain = { DomainName = domain }, size = 0.5 }
        right_pane_top:split { direction = 'Bottom', cwd = cwd, domain = { DomainName = domain }, size = 0.5 }
      end),
    },

    -- 【タブの並べ替え】Ctrl+Shift+Left / Right で左右に移動
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(1) },

    -- 【ランチャーを開く】Ctrl+Shift+O でシンプルなランチャーを表示
    {
      key = 'O',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ShowLauncherArgs {
        flags = 'LAUNCH_MENU_ITEMS|FUZZY',
      },
    },

    -- 【プロジェクトランチャー】Ctrl+Shift+G でプロジェクトを選択してタブを開く
    {
      key = 'G',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        local projects = {
          { id = 'home',         cwd = '~' },
          { id = 'ANEGO/Front',  cwd = '~/top/crm/frontend' },
          { id = 'Aqpina',       cwd = '~/top/aws_aqpina/code/back/laravel' },
          { id = 'トップ名古屋', cwd = '~/top/aws_top-nagoya/code/back/laravel' },
          { id = '履歴書/Front', cwd = '~/top/recruit_form/code/front/react' },
          { id = '履歴書/Back',  cwd = '~/top/recruit_form/code/back/laravel' },
          { id = 'でんき',       cwd = '~/top/denki' },
        }
        local choices = {}
        for _, p in ipairs(projects) do
          table.insert(choices, { label = p.id, id = p.id })
        end
        window:perform_action(
          wezterm.action.InputSelector {
            title = 'プロジェクトを選択',
            choices = choices,
            fuzzy = true,
            action = wezterm.action_callback(function(win, _, id, _)
              if not id then return end
              for _, p in ipairs(projects) do
                if p.id == id then
                  local tab, _, _ = win:mux_window():spawn_tab {
                    args = { 'zsh', '-c', 'cd ' .. p.cwd .. ' && exec zsh --login' },
                    domain = { DomainName = 'WSL:Ubuntu-22.04' },
                  }
                  tab:set_title(p.id)
                  break
                end
              end
            end),
          },
          pane
        )
      end),
    },

    -- 【ペインの移動】Win + h, j, k, l で移動
    { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },

    -- 【デバッグオーバーレイを表示】開発者向けの情報を表示
    {
      key = 'D',
      mods = 'CTRL|SHIFT|ALT',
      action = wezterm.action.ShowDebugOverlay,
    },
  }
end

return module