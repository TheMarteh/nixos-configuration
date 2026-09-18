---------------
---- INPUT ----
---------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        numlock_by_default = true,

        sensitivity   = -0.4, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        -- kan dit ook alleen op touchpad zetten maar nu is het ook voor de muis.
        natural_scroll = true,
    },
})
