local wezterm = require("wezterm")
local config = {}

config.window_background_opacity = 0.75
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
config.enable_tab_bar = false
config.color_scheme = "Noctalia"
config.window_decorations = "RESIZE"
config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 14.0
config.default_prog = { "/usr/bin/fish", "-l" }

return config
