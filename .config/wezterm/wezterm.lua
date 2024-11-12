local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.front_end = "WebGpu"

config.keys = {
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
  -- Please only close the current pane and not the whole tab, like really
  {
    key = 'w',
    mods = 'SUPER',
    action = act.CloseCurrentPane { confirm = true },
  },
  -- If we really want to kill the whole tab, let's still leave an option to do it
  {
    key = 'w',
    mods = 'SUPER|SHIFT',
    action = act.CloseCurrentTab { confirm = true },
  },
  -- -- Multiplexing, trying iTerm style shortcuts for now to keep muscle memory
  -- Pane spawning
  {
    key = 'd',
    mods = 'SUPER',
    action = act.SplitHorizontal,
  },
  {
    key = 'd',
    mods = 'SUPER|SHIFT',
    action = act.SplitVertical,
  },
  -- Pane zoom
  {
    key = 'Enter',
    mods = 'SUPER|SHIFT',
    action = act.TogglePaneZoomState,
  },
  -- Navigate between panes
  {
    key = 'LeftArrow',
    mods = 'SUPER|ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'SUPER|ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'SUPER|ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'SUPER|ALT',
    action = act.ActivatePaneDirection 'Down',
  },
  -- Test for Nicklas
  {
    key = '[',
    mods = 'SUPER',
    action = act.ActivatePaneDirection 'Prev',
  },
  {
    key = ']',
    mods = 'SUPER',
    action = act.ActivatePaneDirection 'Next',
  },
  -- Trying out also this PaneSelect, reminds me of a similar thing I used for i3wm
  {
    key = 'j',
    mods = 'SUPER',
    action = act.PaneSelect,
  },
  -- Trying out ScrollToPrompt
  {
    key = 'p',
    mods = 'SUPER',
    action = act.ScrollToPrompt(-1),
  },
  {
    key = 'p',
    mods = 'SUPER|SHIFT',
    action = act.ScrollToPrompt(1),
  }
}

return config

