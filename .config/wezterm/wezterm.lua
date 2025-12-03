local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Annoying that this is only fetched from compositor on wayland for now
config.max_fps = 144

config.scrollback_lines = 42000
config.color_scheme = 'Tokyo Night'
config.front_end = "WebGpu"
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- I'm blind, maybe - but default size seems too small now (might also depend on the font below)
config.font_size = 14.0
-- Fix crashing on macOS when installed via nixpkgs due to icon rendering breaking.
-- https://github.com/NixOS/nixpkgs/issues/384729#issuecomment-2678113283
config.font = wezterm.font_with_fallback {
  -- Main font
  "ComicShannsMono Nerd Font", -- :)
  -- "CommitMono Nerd Font", -- escape hatch if life is being too funny!
  -- "Hack Nerd Font",
  -- Fallback fonts for Asian characters -> I don't think I have these though, but leaving it for now just to be safe
  "Noto Sans CJK HK",
  "Noto Sans CJK JP",
  "Noto Sans CJK KR",
  "Noto Sans CJK SC",
  "Noto Sans CJK TC",
  -- This is probably not needed, but it doesn't hurt either
  "Noto Sans",
}

-- Disable ligatures on most fonts (sorry, but I don't like them)
-- Source: https://wezfurlong.org/wezterm/config/font-shaping.html
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.unzoom_on_switch_pane = false

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
  },
  -- Tab back and forth between recent tabs
  -- Toggle current and previous
  -- Disabled due to trying out tmux stuff
  -- {
  --   key = 'Tab',
  --   mods = 'CTRL',
  --   action = act.ActivateLastTab,
  -- },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = act.DisableDefaultAssignment,
  },
  -- TODO: Go further back into history.
  -- For now the alternative is cmd+[] or cmd+number
  -- {},
  -- Rename tab interactively
  -- TODO: Find better keybind...
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      -- initial_value = 'My Tab Name', -- nightly only
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  }
}

return config

