-- Hyprland-configuratie in Lua.
-- Sinds Hyprland 0.55 is hyprlang (.conf) deprecated; dit is het formaat dat
-- Hyprland zelf laadt vanaf $XDG_CONFIG_HOME/hypr/hyprland.lua.
--
-- Referentie: https://wiki.hypr.land/Configuring/Start/
-- De meegeleverde voorbeeldconfig staat op
--   /run/current-system/sw/share/hypr/hyprland.lua
-- en de API-stubs (handig voor lua_ls) op
--   /run/current-system/sw/share/hypr/stubs/hl.meta.lua

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "1")

-- NVIDIA (https://wiki.hypr.land/Configuring/Advanced-and-Cool/Nvidia/)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

hl.config({
    -- Hardware cursors op NVIDIA geven een "ghost" muispointer
    cursor = {
        no_hardware_cursors = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})


-----------------------
---- DEELCONFIGS   ----
-----------------------

-- Hyprland zet package.path op deze map, dus require() vindt de buurbestanden.
require("monitors")
require("looknfeel")
require("input")
require("keybindings")


-------------------
---- AUTOSTART ----
-------------------

-- Vervangt exec-once. Deze callback draait alleen bij het opstarten van
-- Hyprland, niet bij `hyprctl reload`.
--
-- swaync staat hier bewust niet tussen: het pakket levert een D-Bus-geactiveerde
-- swaync.service (BusName org.freedesktop.Notifications). Handmatig starten gaf
-- een tweede instantie die de busnaam niet kon claimen -> unit in restart-loop.
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("uwsm app -- blueman-applet")
    hl.exec_cmd("uwsm app -- nm-applet --indicator")
end)


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Negeer maximize-verzoeken van apps.
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Lost sleepproblemen met XWayland op.
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Lost tooltip/hover-geflikker in RuneLite (Bolt) op: de Swing-popups zijn
-- floating XWayland-vensters (class net-runelite-client-RuneLite, titel winNNN).
-- Met follow_mouse = 1 stelen ze focus bij hover, waardoor het hoofdvenster de
-- tooltip verbergt in een flikkerlus.
hl.window_rule({
    name = "runelite-tooltip-flicker",
    match = {
        class = "^(net-runelite-client-RuneLite)$",
        title = "^(win\\d+)$",
        float = true,
    },

    no_focus = true,
})
