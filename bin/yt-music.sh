#!/bin/bash

url=$1

yt-dlp -x --audio-format mp3 --embed-metadata --embed-thumbnail "$1"
