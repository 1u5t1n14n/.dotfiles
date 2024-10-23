local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_wayland = false
config.enable_tab_bar = false

config.window_background_opacity = 0.8
config.text_background_opacity = 0.3

config.font = wezterm.font_with_fallback({
	"JetBrainsMono",
})

config.window_padding = {
	left = "0px",
	right = "0px",
	bottom = "0px",
	top = "0px",
}

config.colors = {
	foreground = "#C5C9C5",
	background = "#181616",

	cursor_bg = "#52ad70", -- Cell when Cursor
	cursor_fg = "black", -- Text when Cursor

	cursor_border = "#52ad70",

	selection_fg = "black", -- Selected Cells
	selection_bg = "#fffacd", -- Selected Text

	-- The color of the scrollbar "thumb"; the portion that represents the current viewport
	scrollbar_thumb = "#222222",

	-- The color of the split lines between panes
	split = "#444444",

	ansi = {
		"black",
		"maroon",
		"green",
		"olive",
		"navy",
		"purple",
		"teal",
		"silver",
	},
	brights = {
		"grey",
		"red",
		"lime",
		"yellow",
		"blue",
		"fuchsia",
		"aqua",
		"white",
	},

	-- Arbitrary colors of the palette in the range from 16 to 255
	indexed = { [136] = "#af8700" },

	-- When the IME, a dead key or a leader key are being processed and are effectively
	-- holding input pending the result of input composition, change the cursor
	-- to this color to give a visual cue about the compose state.
	compose_cursor = "orange",

	-- In copy_mode, the color of the active text is:
	-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
	-- 2. selection_* otherwise
	copy_mode_active_highlight_bg = { Color = "#000000" },

	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },
}

config.window_background_gradient = {
  orientation = 'Horizontal',

  colors = {
    '#0f0c29',
    '#302b63',
    '#24243e',
  },

  interpolation = 'Linear',

  blend = 'Rgb',
}

return config
