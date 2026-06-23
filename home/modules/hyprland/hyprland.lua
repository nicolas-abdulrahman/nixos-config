mainMod = "SUPER"

hl.config({
    xwayland = {
        enabled = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 2,
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
    monitor = "DP-1",
    maximize = true
})

hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("xdg-open ~"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("wezterm"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("krita"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("gimp"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("equicord --enable-features=UseOzonePlatform --ozone-platform=wayland"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("prismlauncher"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("st"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("surf"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("pkill waybar"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("waybar"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))


hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("grimblast save area"))

hl.bind(mainMod .. " + Tab", function()
    hl.dispatch("swapactiveworkspaces", "current +1")
    hl.dispatch("focusmonitor", "+1")
end)

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local keys    = { "left", "right", "up", "down" }
local keys_v  = { "h", "l", "k", "j" }
local targets = { "left", "right", "up", "down" }

for i = 1, 4 do
    hl.bind(mainMod .. " + " .. keys[i], hl.dsp.focus({ direction = targets[i] }))
    hl.bind(mainMod .. " + " .. keys_v[i], hl.dsp.focus({ direction = targets[i] }))
end

for i = 1, 10 do
    local key = (i == 10) and "0" or tostring(i)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
