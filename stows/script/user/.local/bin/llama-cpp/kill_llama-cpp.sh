#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && kill $(cat "$pid_file")
: > "$pid_file"
