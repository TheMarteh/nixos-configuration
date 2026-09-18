---------------------
---- KEYBINDINGS ----
---------------------

-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Programma's die aan een toets hangen
local terminal    = "alacritty"
local fileManager = "dolphin"
local menu        = 'rofi -show drun -run-command "uwsm app -- {cmd}"'
local runMenu     = 'rofi -show run -run-command "uwsm app -- {cmd}"'

-- Applicaties
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(runMenu))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("uwsm app -- firefox"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("uwsm app -- code"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e lazydocker"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("uwsm app -- whatsapp-electron"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- bolt-launcher"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- " .. fileManager))

-- Vensterbeheer
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())          -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle

-- Uitloggen/herstarten/afsluiten via hyprshutdown: sluit eerst alle apps netjes af
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprshutdown -t 'Uitloggen...'"))
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("hyprshutdown -t 'Herstarten...' -p 'systemctl reboot'"))
hl.bind(mainMod .. " + CTRL + SHIFT + P", hl.dsp.exec_cmd("hyprshutdown -t 'Afsluiten...' -p 'systemctl poweroff'"))

-- Scherm uitzetten
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("~/nixos-configuration/config/hypr/scripts/dpms-toggle.sh"))

-- Focus verplaatsen met mainMod + pijltjestoetsen
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces wisselen met mainMod + [0-9]
-- Actief venster naar een workspace met mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 wordt toets 0
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Speciale workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Door workspaces scrollen met mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Vensters verplaatsen/schalen met mainMod + LMB/RMB en slepen
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimediatoetsen voor volume en helderheid
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Vereist playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshots met grim en slurp
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png'))
hl.bind("PRINT",         hl.dsp.exec_cmd("grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"))

-- Notificaties
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
