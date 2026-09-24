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
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("sysmenu"))
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

-- Vergrendelen, slaapstand, uitloggen, herstarten en afsluiten zitten samen in
-- één rofi-menu (power-menu, zie home/menu.nix), dat ook onder SUPER+SPACE >
-- Systeem > Aan/uit hangt. Geen aparte toets per actie meer: kiezen is meteen
-- bevestigen, en een misgrepen toets kost geen sessie.
hl.bind(mainMod .. " + CTRL + SHIFT + P", hl.dsp.exec_cmd("power-menu"))

-- Vergrendelen en screensaver. Via loginctl, zodat het langs hypridle's
-- lock_cmd loopt en de sessie ook echt als vergrendeld geldt (zie home/idle.nix).
-- Het scherm handmatig uitzetten zit in het systeemmenu.
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + ALT + S",   hl.dsp.exec_cmd("screensaver"))

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

-- Multimediatoetsen. Via swayosd-client in plaats van rechtstreeks wpctl /
-- brightnessctl / playerctl: dat doet hetzelfde en laat er een on-screen
-- display bij zien. Zie home/desktop.nix.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          { locked = true, repeating = true })

-- Caps Lock heeft geen lampje op dit toetsenbord.
hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { locked = true, release = true })

-- Vereist playerctl, dat swayosd zelf aanroept
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("swayosd-client --playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("swayosd-client --playerctl prev"),       { locked = true })

-- Vastleggen. Alles gaat via satty (annoteren) naar het klembord en naar
-- ~/Pictures/Screenshots; zie home/capture.nix.
hl.bind("PRINT",         hl.dsp.exec_cmd("screenshot region"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("screenshot window"))
hl.bind("CTRL + PRINT",  hl.dsp.exec_cmd("screenshot output"))
hl.bind(mainMod .. " + PRINT",     hl.dsp.exec_cmd("screenrecord"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Klembordgeschiedenis en emoji's
hl.bind(mainMod .. " + CTRL + V",     hl.dsp.exec_cmd("clipboard-history"))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd("rofimoji --selector rofi --clipboarder wl-copy"))

-- Notificaties
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
