#!/bin/bash
tmux-session "$(find $PWD -maxdepth 1 -type d | fzf)"
