local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Setup colorscheme
config.color_scheme = "Catppuccin Mocha"

local mocha = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

-- Setup font
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMonoNL Nerd Font" },
  { family = "JetBrainsMonoNL Nerd Font", scale = 0.95 },
})

config.font_size = 14.0
config.line_height = 1.0

-- Disable window decorations
-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.window_padding = { left = 15, right = 0, top = 0, bottom = 0 }

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false -- Move tab bar to the top
config.tab_max_width = 32
-- config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.colors = {
  tab_bar = {
    background = mocha.crust,
    active_tab = {
      bg_color = mocha.base,
      fg_color = mocha.lavender,
    },
    inactive_tab = {
      bg_color = mocha.mantle,
      fg_color = mocha.subtext0,
    },
    inactive_tab_hover = {
      bg_color = mocha.surface0,
      fg_color = mocha.text,
    },
    new_tab = {
      bg_color = mocha.surface0,
      fg_color = mocha.subtext0,
    },
    new_tab_hover = {
      bg_color = mocha.surface1,
      fg_color = mocha.text,
    },
  },
}

config.keys = {
  -- Option + Left: Move cursor one word left
  { key = "LeftArrow",  mods = "OPT", action = wezterm.action.SendString("\x1b\x62") },
  -- Option + Right: Move cursor one word right
  { key = "RightArrow", mods = "OPT", action = wezterm.action.SendString("\x1b\x66") },
  -- Command + Left: Move cursor to beginning of line
  { key = "LeftArrow",  mods = "CMD", action = wezterm.action.SendString("\x01") },
  -- Command + Right: Move cursor to end of line
  { key = "RightArrow", mods = "CMD", action = wezterm.action.SendString("\x05") },
  -- Command + Delete: Delete whole line to the left of cursor
  { key = "Backspace",  mods = "CMD", action = wezterm.action.SendString("\x15") },

}

return config
