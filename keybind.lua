local wezterm = require 'wezterm'
local notify = require 'notify'
local module = {}

-- タブタイトルの末尾 (N) をインクリメント、なければ (1) を付加
local function next_tab_title(window)
  local title = window:active_tab():get_title()
  local base, n = title:match('^(.-)%s*%((%d+)%)$')
  if base and n then
    return base .. ' (' .. (tonumber(n) + 1) .. ')'
  else
    return title .. ' (1)'
  end
end

function module.apply_to_config(config)
  config.keys = {
    -- 【入力待ち表示】Enterを送ったらアクティブペインの待機状態を解除
    {
      key = 'Enter',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        notify.clear_waiting(pane)
        window:perform_action(wezterm.action.SendKey { key = 'Enter' }, pane)
      end),
    },

    -- 【クリップボード】
    { key = 'V',      mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT',      action = wezterm.action.PasteFrom 'Clipboard' },

    -- 【タブ操作】
    { key = 'W', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
    { key = 'P', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab { args = { 'powershell.exe' }, domain = { DomainName = 'local' } } },
    { key = 'S', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'B', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

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
      action = wezterm.action_callback(function(window, pane)
        local title = next_tab_title(window)
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and cwd_uri.file_path or nil
        local tab, _, _ = window:mux_window():spawn_tab {
          domain = { DomainName = 'WSL:Ubuntu-22.04' },
          cwd = cwd,
        }
        tab:set_title(title)
      end),
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
        local title = next_tab_title(window)
        local cwd = ""
        local cwd_uri = pane:get_current_working_dir()
        if cwd_uri then cwd = cwd_uri.file_path end
        local domain = 'WSL:Ubuntu-22.04'

        -- 左側に1つ、右側に上下2つのレイアウトを作成
        local tab, left_pane, window = window:mux_window():spawn_tab { cwd = cwd, domain = { DomainName = domain } }
        tab:set_title(title)
        local right_pane_top = left_pane:split { direction = 'Right', cwd = cwd, domain = { DomainName = domain }, size = 0.5 }
        right_pane_top:split { direction = 'Bottom', cwd = cwd, domain = { DomainName = domain }, size = 0.5 }

        -- 分割完了後に右上のペインにカーソルを移動
        right_pane_top:activate()
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
          { id = 'ANEGO/Front',  cwd = '~/top/crm/frontend' },
          { id = 'ANEGO/Back',  cwd = '~/top/crm/backend' },
          { id = 'ANEGO/GCP',  cwd = '~/top/crm/gcp' },
          { id = 'Aqpina',       cwd = '~/top/aws_aqpina/code/back/laravel' },
          { id = 'top-nagoya', cwd = '~/top/aws_top-nagoya/code/back/laravel' },
          { id = 'TOP-AUTH',       cwd = '~/top/top-auth' },
          { id = 'recruit_form/Front', cwd = '~/top/recruit_form/code/front/react' },
          { id = 'recruit_form/Back',  cwd = '~/top/recruit_form/code/back/laravel' },
          { id = 'denki',       cwd = '~/top/denki' },
          { id = 'TMS',       cwd = '~/top/tms/code ' },
          { id = 'meibo',       cwd = '~/top/meibo/code/meibo ' },
          { id = 'NVIM',        cwd = '~/.config/nvim' },
          { id = 'Download',        cwd = '/mnt/c/Users/k-katsuno3050/Downloads' },
          { id = 'temp',        cwd = '~/temp' },
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

    -- 【ペインの移動】CTRL|SHIFT + h, j, k, l で移動
    { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },

    -- 【ペインの最大化】現在のペインを最大化、または元の分割表示に戻す
    { key = 'Z', mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState },

    -- 【デバッグオーバーレイを表示】開発者向けの情報を表示
    {
      key = 'D',
      mods = 'CTRL|SHIFT|ALT',
      action = wezterm.action.ShowDebugOverlay,
    },
  }
end

return module
