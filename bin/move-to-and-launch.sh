#!/bin/bash

original_id=$(niri msg --json focused-window | jq .id)
req_id=$(niri msg --json windows | jq --arg app_id "$3" '.[] | select(.app_id == $app_id) | .id')

if [[ ! -z "${req_id}" ]]; then
	notify-send "'$3' already open"
	exit 
fi

niri msg action focus-monitor "$1"
echo "$2" | nohup bash &
sleep 0.5
niri msg action consume-or-expel-window-left
niri msg action move-window-up

niri msg action focus-window --id $original_id
