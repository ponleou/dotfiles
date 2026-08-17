#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

pid_file="$LLAMA_CACHE/pid"

if [[ -s "$pid_file" ]]; then
    pid=$(<"$pid_file")
    kill "$pid"
    
    while kill -0 "$pid" 2>/dev/null; do
        sleep 0.2
    done
fi

: > "$pid_file"
