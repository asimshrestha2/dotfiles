#!/bin/bash

list=(
	"waybar"
	"mako"
	"sway"
	"swaync"
	"swaylock"
	"rofi"
	"xdg-desktop-portal"
	"xdg-desktop-portal-wlr"
	"niri"
	"systemd",
	"fish"
	"ghostty"
	# "fastfetch"
)

for i in "${list[@]}"; do
	rsync --verbose --recursive "/home/$USER/.config/$i" "./.config"
done
