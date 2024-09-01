
--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
--

local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.enable_wayland = false
config.enable_tab_bar = false

config.font_size = 11
-- config.font = wezterm.font_with_fallback {
--   'Noto Sans Mono CJK JP'
-- }
config.font = wezterm.font 'JetBrainsMono'


config.window_padding = {
  left = "0px",
  right = "0px",
  bottom = "0px",
  top = "0px",
}

config.colors = {
  foreground = '#C5C9C5',
  background = '#181616',

  cursor_bg = '#C8C093',
  cursor_fg = '#C8C093',
  cursor_border = '#C8C093',

  selection_fg = 'black',
  selection_bg = '#C8C093',

  ansi = {
    'black',
    'maroon',
    'green',
    'olive',
    'navy',
    'purple',
    'teal',
    'silver',
  },
  brights = {
    'grey',
    'red',
    'lime',
    'yellow',
    'blue',
    'fuchsia',
    'aqua',
    'white',
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = '#af8700' },

  compose_cursor = 'orange',

  copy_mode_active_highlight_bg = { Color = '#000000' },
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },
}

return config
