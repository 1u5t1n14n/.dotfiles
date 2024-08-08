local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.enable_wayland = false
config.enable_tab_bar = false

config.font_size = 11
config.font = wezterm.font 'JetBrainsMono'

config.window_padding = {
  left = "0px",
  right = "0px",
  bottom = "0px",
  top = "0px",
}

config.colors = {
  tab_bar = {
    background = '#2a2a37',
    active_tab = {
      bg_color = '#54546d',
      fg_color = '#dcd7ba',
      italic = true,
    },
    inactive_tab = {
      bg_color = '#363646',
      fg_color = '#727169'
    },
    new_tab = {
      bg_color = '#363646',
      fg_color = '#717c7c'
    }
  }
}

return config
