#!/bin/zsh

log_file=/dev/null
if [[ -n "$LLAMA_CACHE" ]]; then
    log_file="$(basename "$0").log"    
fi

nohup llama serve -hf unsloth/Qwen3.6-35B-A3B-MTP-GGUF:Q3_K_XL -ngl 999 --n-cpu-moe 28 -c 42158 -fa 1 -ctk q8_0 -ctv q8_0 --spec-type draft-mtp --spec-draft-n-max 2 -np 1 --temp 0.6 --top-p 0.95 --top-k 20 --min_p 0.0 --presence-penalty 0 --no-mmproj 2>&1 | awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> "$log_file" &


