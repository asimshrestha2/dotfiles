#!/bin/bash

list=(
	"waybar"
	"mako"
	"sway"
	"swaylock"
	"rofi"
	# "fastfetch"
)

for i in "${list[@]}"; do
	rsync --recursive "/home/$USER/.config/$i" "./.config"
done
