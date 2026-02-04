#!/bin/bash

GODOT_REPO=godotengine/godot
GITHUB_API="https://api.github.com/repos/$GODOT_REPO/releases"

echo "-- Godot Downloader --"

ARCH=$(uname -m)

list() {
	local json_list=$(curl -s "$GITHUB_API")
	echo "$json_list" | jq -r 'map(.tag_name) | sort | .[]'
}

download_godot() {
	local version="latest"
	if [[ "$1" != "latest" ]]; then
		echo "Need to check version"
	fi

	local json=$(curl -s "$GITHUB_API/$version")
	local tag_name=$(echo "$json" | jq -r '.tag_name')

	local download_name="Godot_v${tag_name}_linux.${ARCH}"
	local download_url="https://github.com/godotengine/godot/releases/download/${tag_name}/$download_name.zip"
	curl -L -O "$download_url"
	unzip -o "$download_name.zip"

	local link_loc="/home/$USER/.local/bin/godot"
	mkdir -p "/home/$USER/.local/bin/"

	if [[ -L "$link_loc"  ]]; then
		echo "removing old godot bin file"
		rm $link_loc
	fi

	ln -s "$(pwd)/$download_name" "/home/$USER/.local/bin/godot"
	echo "Godot version updated"
}

case "$1" in
	"--list")
		list
		;;
	*)
		if [[ -n "$1" ]]; then
			download_godot $1
			exit 1
		fi
		echo "Downloading the latest version of Godot"
		download_godot
		;;
esac

