#!/bin/bash
SESSION_NAME="potato"

if [[ -n "$1" ]]; then
	SESSION_NAME=$(basename "$1")
fi

tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
 tmux attach-session -t $SESSION_NAME
else
if [[ -n "$1" ]]; then
 tmux new-session -s $SESSION_NAME -d -c $1
else
 tmux new-session -s $SESSION_NAME -d
fi
 tmux attach-session -t $SESSION_NAME
fi

