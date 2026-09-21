#!/usr/bin/env bash

# Zet de schermen uit of weer aan. Een druk op een toets of een muisbeweging
# haalt ze ook terug (misc.key_press_enables_dpms / mouse_move_enables_dpms).
#
# Sinds Hyprland 0.55 leest `hyprctl dispatch` zijn argument als Lua; de oude
# vorm `hyprctl dispatch dpms toggle` geeft een parsefout en doet niets.
hyprctl dispatch 'hl.dsp.dpms("toggle")'
