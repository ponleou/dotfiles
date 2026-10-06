#!/bin/zsh

[[ -z "$LLAMA_CACHE" ]] && exit 1

log_file="$LLAMA_CACHE/$(basename "$0").log"    
pid_file="$LLAMA_CACHE/pid"

[[ -s "$pid_file" ]] && exit 1

GGML_VK_VISIBLE_DEVICES=1 nohup llama serve -hf unsloth/Qwen3.6-35B-A3B-MTP-GGUF:Q3_K_XL -ngl 999 --n-cpu-moe 30 -c 98304 -fa 1 -ctk q8_0 -ctv q8_0 --spec-type draft-mtp --spec-draft-n-max 2 -np 1 --temp 0.6 --top-p 0.95 --top-k 20 --min_p 0.0 --presence-penalty 0 --no-mmproj --jinja > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush() }' >> "$log_file") 2>&1 &

echo $! > "$pid_file"
