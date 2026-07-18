mainMod = "SUPER"
main_monitor      = "HDMI-A-1" -- <-- Change this to the main monitor name from hyprctl
secondary_monitor = "DP-1"

-- MONITORS
-- Since Hyprland 0.55, monitors are configured with individual hl.monitor() calls,
-- not a `monitor = {...}` table inside hl.config(). "auto-right" also isn't a real
-- position keyword — plain "auto" places a monitor to the right of whatever was
-- declared before it, so declaring secondary first and main second puts
-- secondary on the left and main on the right.
hl.monitor({
    output   = secondary_monitor,
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output   = main_monitor,
    mode     = "preferred",
    position = "auto", -- auto-places to the right of secondary_monitor
    scale    = "auto",
})

hl.config({
    xwayland = {
        enabled = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1, -- 1 = cursor movement always focuses the window under it
        sensitivity = 0,
    },
    general = {
        gaps_in = -25,
        gaps_out = 0,
        border_size = 2,
        layout = "master",
    },
    decoration = {
        inactive_opacity = 0.8,
        active_opacity = 1.0,
        rounding = 10,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = "rgba(00000066)",
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        enable_anr_dialog = false,
        force_default_wallpaper = 0,
    },
    master = {
        new_status = "master",
    },
})

hl.window_rule({
    match = {
        class = "^[Gg]odot$",
        title = ".*Godot Engine.*"
    },
    fullscreen = true
})
hl.window_rule({
    match = {
        class = "^[Gg]odot$",
        title = ".*DEBUG.*"
    },
    monitor = secondary_monitor,
    maximize = true
})

hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("xdg-open ~"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("wezterm"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("krita"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("gimp"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("equicord --enable-features=UseOzonePlatform --ozone-platform=wayland"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("prismlauncher"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("st"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("surf "))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("pkill waybar"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("waybar"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("grimblast save area"))

-- Cycle focus to the next monitor.
-- focus() accepts a monitor selector directly ("+1"/"-1"/name/direction/"current"),
-- so this single dispatcher call replaces the old broken two-string hl.dispatch() calls.
local hs = require("hyprsplit")
hl.bind(mainMod .. " + Tab", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local keys    = { "left", "right", "up", "down" }
local keys_v  = { "h", "l", "k", "j" }
local targets = { "left", "right", "up", "down" }

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
end)

for i = 1, 4 do
    hl.bind(mainMod .. " + " .. keys[i], hl.dsp.focus({ direction = targets[i] }))
    hl.bind(mainMod .. " + " .. keys_v[i], hl.dsp.focus({ direction = targets[i] }))
end

for i = 1, 10 do
    local key = (i == 10) and "0" or tostring(i)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- WORKSPACES
-- 1-5 live on the main monitor, 6-0 (i.e. workspaces 6-10) live on the secondary monitor.
for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = main_monitor,
        default = (i == 1),
        persistent = true,
    })
end

for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = secondary_monitor,
        default = (i == 6),
        persistent = true,
    })
end
