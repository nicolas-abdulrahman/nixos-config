local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.color_scheme = "Dracula"
-- config.colors.background= 'none'
-- config.disable_default_key_bindings = true
--config.window_background_image = '/etc/nixos/vicksy.jpg'
--config.window_background_image_hsb = {
-- Darken the background image by reducing it to 1/3rd
--  brightness = 0.1,

-- You can adjust the hue by scaling its value.
-- a multiplier of 1.0 leaves the value unchanged.
--  hue = 1.0,

-- You can adjust the saturation also.
-- saturation = 0.9,
--}

local wezterm_mod = "ALT"
config.keys = {
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "/", mods = wezterm_mod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = wezterm_mod, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = wezterm_mod, action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = wezterm_mod, action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = wezterm_mod, action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = wezterm_mod, action = act.ActivatePaneDirection("Right") },
	{ key = "1", mods = wezterm_mod, action = act.ActivateTab(0) },
	{ key = "2", mods = wezterm_mod, action = act.ActivateTab(1) },
	{ key = "3", mods = wezterm_mod, action = act.ActivateTab(2) },
	{ key = "4", mods = wezterm_mod, action = act.ActivateTab(3) },
	{ key = "n", mods = wezterm_mod, action = act.SpawnWindow },
	{ key = "t", mods = wezterm_mod, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "Enter", mods = wezterm_mod, action = act.ToggleFullScreen },
	{ key = "q", mods = wezterm_mod, action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "[", mods = wezterm_mod, action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = wezterm_mod, action = act.ActivateTabRelative(1) },
	{ key = "f", mods = wezterm_mod, action = act.Search({ CaseSensitiveString = "" }) },
	{ key = "d", mods = wezterm_mod, action = act.CloseCurrentPane({ confirm = true }) },
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

config.default_prog = { "zsh", "-c", "tmux attach || tmux" }

return config
