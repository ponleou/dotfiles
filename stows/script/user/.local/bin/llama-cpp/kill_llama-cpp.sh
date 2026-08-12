#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

pid_file="$LLAMA_CACHE/pid"

kill $(cat "$pid_file")
echo "" > "$pid_file"
