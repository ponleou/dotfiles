#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

log_file="$LLAMA_CACHE/$(basename "$0").log"    
pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && exit 1

nohup llama-server --device Vulkan1 -hf LiquidAI/LFM2.5-24B-A2B-GGUF:Q4_0 -ngl 999 --n-cpu-moe 22 -c 65536 -fa 1 -ctk f16 -ctv f16 --load-mode none -np 1 --temp 0.1 --top-k 50 --repeat-penalty 1.05 --no-mmproj --jinja --port 9931 > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush() }' >> "$log_file") 2>&1 &

echo $! > "$pid_file"
