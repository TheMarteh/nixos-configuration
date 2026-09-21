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

-- Hier staat bewust geen hl.env(). Alles start via `uwsm app --`, dus als
-- systemd-user-unit, en die erven hun omgeving van de user manager -- niet van
-- Hyprland. De cursor-, schaal- en NVIDIA-variabelen staan daarom in
-- home/wayland-env.nix, dat ~/.config/environment.d vult.

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
require("windowrules")


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
