local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.color_scheme = "Dracula"
local wezterm_mod = "CTRL|SHIFT"

-- Font rules with explicit Arabic font rendering
config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "Regular" },
  { family = "IBM Plex Sans Arabic", weight = "Medium" }, -- Bolder weight makes strokes clearer
  "Noto Color Emoji",
})
config.bidi_enabled = true
config.bidi_direction = "LeftToRight"
config.line_height = 1.25
config.font_size = 13.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
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
	{
		key = "t",
		mods = wezterm_mod,
		action = act.SpawnCommandInNewTab({
            args = { "zsh", "-c", "tmux new-session; zsh -i" },
		}),
	},
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

config.default_prog = {
      'fish',
      '-c',
      [[
        set -l session "0"
        if set -q WORKSPACE
          set session $WORKSPACE
        else if set -q argv[1]
          set session $argv[1]
        end
      hyprctl notify 1 5000 0 $WORKSPACE

        if tmux has-session -t $session 2>/dev/null
          tmux new-session -t $session
        else
          tmux new-session -s $session -n $session
        end

        fish -i
      ]],
      '--'
    }
return config
