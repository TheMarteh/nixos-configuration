#!/usr/bin/env bash

# Check of displays momenteel aan staan:
if hyprctl monitors | grep -q "dpmsStatus: 1"; then
    hyprctl dispatch dpms off
else
    hyprctl dispatch dpms on
fi