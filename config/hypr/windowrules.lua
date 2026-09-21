-----------------------
---- WINDOW RULES  ----
-----------------------

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--
-- De sleutels in `match` zijn voorwaarden, de sleutels daarbuiten zijn de regel
-- zelf (snake_case van de hyprland-regelnaam).

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


-------------------
---- TUI-MODALS ----
-------------------

-- De terminals die `tui-modal` opent (klik op een waybar-icoon). Ze krijgen een
-- eigen class mee via `alacritty --class`, zodat ze hier te vangen zijn en niet
-- in de tiling belanden. Zie home/tui-modals.nix.
hl.window_rule({
    name = "tui-modal",
    match = { class = "^(Wifi|Bluetooth|Wiremix|Btop)$" },

    float  = true,
    size   = { 1100, 700 },
    center = true,
})
