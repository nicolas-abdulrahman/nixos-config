    local mainMod = "SUPER"
    local main_monitor      = "HDMI-A-1"
    local secondary_monitor = "DVI-D-1"

    local hs = require("hyprsplit")

    -- ============================================================================
    -- MONITORS
    -- ============================================================================
    hl.monitor({
        output   = secondary_monitor,
        mode     = "preferred",
        position = "0x0",
        scale    = "auto",
    })

    hl.monitor({
        output   = main_monitor,
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })

    -- ============================================================================
    -- COMPOSITOR CONFIG
    -- ============================================================================
    hl.config({
        xwayland = {
            enabled = true,
        },
        input = {
            kb_layout = "us",
            follow_mouse = 1,
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

    -- ============================================================================
    -- WINDOW RULES
    -- ============================================================================
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

    -- ============================================================================
    -- APP & UTILITY BINDINGS
    -- ============================================================================
    hl.bind(mainMod .. " + Y", function()
        local ws = hl.get_active_workspace()
        local name = "0"
        if ws then
            if ws.name and ws.name:match("^special:(.+)") then
                name = ws.name:match("^special:(.+)") -- extracts "ai", "browser", "other"
            elseif ws.id then
                -- Maps secondary monitor workspaces (11-20) back to slot 1-10:
                name = tostring((ws.id > 10 and ws.id <= 20) and (ws.id - 10) or ws.id)
            end
        end

        hl.notification.create({
            text = string.format("%s workspace name: %s ",ws, name),
            duration = "5000",
          font_size = 25,
            icon = 1,		  -- Info icon
            color = "rgb(89b4fa)",    -- Optional color
        })
        hl.exec_cmd(string.format("env WORKSPACE=%s wezterm", name))
    end)
        --
    
    hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))
    hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("eww open --toggle searchbar"))
    -- hl.bind(mainMod .. " + A", hl.dsp.window.fullscreen({ action = "toggle" }))
    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("xdg-open ~"))
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
    hl.bind(mainMod .. " + CTRL + SHIFT + M", hl.dsp.exec_cmd("systemctl hibernate"))
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
    hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("grimblast save area"))

    -- ============================================================================
    -- WORKSPACE PAIRS (0-9 SLOTS) & MONITOR SWAP
    -- ============================================================================
    -- SUPER + Tab swaps active screen contents between the two monitors
    hl.bind(mainMod .. " + Tab", hs.dsp.workspace.swap_monitors({
        monitor1 = main_monitor,
        monitor2 = secondary_monitor
    }))

    -- Switches both monitors together to Slot N, keeping focus on whichever monitor was active
    local function switch_pair(slot)
        return function()
            local active_mon = hl.get_active_monitor()
            local main_ws = slot
            local sec_ws  = slot + 10

            -- Switch secondary monitor to sec_ws, then main monitor to main_ws
            hl.dispatch(hl.dsp.focus({ monitor = secondary_monitor }))
            hl.dispatch(hl.dsp.focus({ workspace = sec_ws }))
            hl.dispatch(hl.dsp.focus({ monitor = main_monitor }))
            hl.dispatch(hl.dsp.focus({ workspace = main_ws }))

            -- If the user was focused on secondary monitor, return focus there
            if active_mon and active_mon.name == secondary_monitor then
                hl.dispatch(hl.dsp.focus({ monitor = secondary_monitor }))
            end
        end
    end

    -- Moves focused window to slot's workspace on current monitor
    local function move_window_to_pair(slot)
        return function()
            local active_mon = hl.get_active_monitor()
            local target_ws = (active_mon and active_mon.name == secondary_monitor) and (slot + 10) or slot
            hl.dispatch(hl.dsp.window.move({ workspace = target_ws }))
        end
    end

    -- Binds 1..9 and 0 (slot 10)
    for i = 1, 10 do
        local key = (i == 10) and "0" or tostring(i)
        hl.bind(mainMod .. " + " .. key, switch_pair(i))
        hl.bind(mainMod .. " + SHIFT + " .. key, move_window_to_pair(i))
    end

    -- ============================================================================
    -- SPECIAL WORKSPACES: "ai", "browser", "other" (WIN + SPACE -> a/b/o)
    -- ============================================================================
    hl.bind(mainMod .. " + SPACE", hl.dsp.submap("special_ws"))

    hl.define_submap("special_ws", function()
        local function toggle_special_and_reset(name)
            return function()
                hl.dispatch(hl.dsp.workspace.toggle_special(name))
                hl.dispatch(hl.dsp.submap("reset"))
            end
        end

        -- Toggle "ai" (SUPER+SPACE then a or SUPER+a)
        hl.bind("a", toggle_special_and_reset("ai"))
        hl.bind(mainMod .. " + a", toggle_special_and_reset("ai"))

        -- Toggle "browser" (SUPER+SPACE then b or SUPER+b)
        hl.bind("b", toggle_special_and_reset("browser"))
        hl.bind(mainMod .. " + b", toggle_special_and_reset("browser"))

        -- Toggle "other" (SUPER+SPACE then o or SUPER+o)
        hl.bind("o", toggle_special_and_reset("other"))
        hl.bind(mainMod .. " + o", toggle_special_and_reset("other"))

        -- Cancel / exit submap
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("space", hl.dsp.submap("reset"))
        hl.bind(mainMod .. " + space", hl.dsp.submap("reset"))
        hl.bind("catchall", hl.dsp.submap("reset"), { catchall = true })
    end)

    -- ============================================================================
    -- WINDOW NAVIGATION & MOUSE
    -- ============================================================================
    -- Middle click focuses next monitor
    hl.bind(mainMod .. " + mouse:274", hl.dsp.focus({ monitor = "+1" }))

    -- Drag / resize windows with mouse
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Directional focus (Arrow keys & HJKL)
    local keys    = { "left", "right", "up", "down" }
    local keys_v  = { "h", "l", "k", "j" }
    local targets = { "left", "right", "up", "down" }

    for i = 1, 4 do
        hl.bind(mainMod .. " + " .. keys[i], hl.dsp.focus({ direction = targets[i] }))
        hl.bind(mainMod .. " + " .. keys_v[i], hl.dsp.focus({ direction = targets[i] }))
    end

    -- ============================================================================
    -- AUTOSTART
    -- ============================================================================
    hl.on("hyprland.start", function()
        -- Daemons & Background tools
        hl.exec_cmd("hypridle")
        hl.exec_cmd("hyprpaper")



       hl.exec_cmd("[workspace 1 silent] env WORKSPACE=1 wezterm")
        hl.exec_cmd("[workspace 11 silent] env WORKSPACE=1 wezterm")

        hl.exec_cmd("[workspace special:browser silent] firefox")
    end)

    -- ============================================================================
    -- WORKSPACE STATIC ASSIGNMENTS
    -- ============================================================================
    -- Main monitor gets 1-10
    for i = 1, 10 do
        hl.workspace_rule({
            workspace = tostring(i),
            monitor = main_monitor,
            default = (i == 1),
            persistent = true,
        })
    end

    -- Secondary monitor gets 11-20
    for i = 11, 20 do
        hl.workspace_rule({
            workspace = tostring(i),
            monitor = secondary_monitor,
            default = (i == 11),
            persistent = true,
        })
    end


