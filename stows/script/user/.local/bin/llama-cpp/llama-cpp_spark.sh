#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

log_file="$LLAMA_CACHE/$(basename "$0").log"    
pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && exit 1

nohup llama-server --device Vulkan1 -hf peculiar-ragdoll/Sharp-Spark-X2.6-4B-GGUF:Q6_K_XL -ngl all -c 128000 -ctk f16 -ctv q8_0 -np 1 --temp 1.0 --top-p 0.95 --top-k -1 --min_p 0.0 --presence_penalty 0.0 --repeat_penalty 1.0  --no-mmproj --jinja --port 9931 > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush() }' >> "$log_file") 2>&1 &

echo $! > "$pid_file"
