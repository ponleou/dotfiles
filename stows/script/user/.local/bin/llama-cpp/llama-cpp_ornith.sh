#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

log_file="$LLAMA_CACHE/$(basename "$0").log"    
pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && exit 1

nohup llama-server --device Vulkan1 -hf ornith-ai/Ornith-1.5-9B-GGUF:Q4_K_M -ngl all --spec-type draft-mtp --spec-draft-n-max 1 --spec-draft-p-min 0.0 -c 124000 -ctk q8_0 -ctv q8_0 -np 1 --temp 0.6 --top-p 0.95 --top-k 20 --min_p 0.0 --presence_penalty 0.0 --repeat_penalty 1.0  --no-mmproj --jinja --port 9931 > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush() }' >> "$log_file") 2>&1 &

echo $! > "$pid_file"
