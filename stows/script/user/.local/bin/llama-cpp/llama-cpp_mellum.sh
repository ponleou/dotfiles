#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

log_file="$LLAMA_CACHE/$(basename "$0").log"    
pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && exit 1

nohup llama-server --device Vulkan1 -hf JetBrains/Mellum2.1-12B-A2.5B-Thinking-GGUF:Q6_K -ngl 999 --n-cpu-moe 12 -b 512 -ub 256 -c 131072 -fa 1 -ctk f16 -ctv f16 --load-mode mmap -np 1 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 0 --no-mmproj --jinja --port 9931 > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush() }' >> "$log_file") 2>&1 &

echo $! > "$pid_file"
