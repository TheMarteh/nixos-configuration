----------------
---- MONITORS --
----------------

-- https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Schaal moet de resolutie deelbaar maken tot hele pixels:
-- 2560x1440 / 1.333333 = 1920x1080.
-- (1.3333 wordt afgerond naar 1.33 -> 1924.8px breed -> rendering-artifacts.)
hl.monitor({
    output   = "DP-5",
    mode     = "2560x1440@75",
    position = "0x0",
    scale    = 1.333333,
})

-- Fallback voor elk ander (tijdelijk) aangesloten scherm
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})
