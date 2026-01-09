#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
COMMIT_TIMER_PID=""
SYNC_TIMER_PID=""


trigger_commit_after_wait() {
  COMMIT_TIMER_FILE="$SCRIPT_DIR/../tmp/COMMIT_TIMER_PID"

    # get PID from file
  if [ -f "$COMMIT_TIMER_FILE" ]; then
    COMMIT_TIMER_PID="$(cat "$COMMIT_TIMER_FILE")"
  fi

  # kill process if PID exist
  if [ -n "$COMMIT_TIMER_PID" ]; then
    kill "$COMMIT_TIMER_PID"
    COMMIT_TIMER_PID="" 
  fi

    (
    sleep 60 &
    COMMIT_TIMER_PID=$!

    # echo into file for next run to kill process
    if [ -f "$COMMIT_TIMER_FILE" ]; then
      echo "$COMMIT_TIMER_PID" > "$COMMIT_TIMER_FILE"
    fi

    # wait for sleep before running script
    wait $COMMIT_TIMER_PID && bash "$SCRIPT_DIR/commit-stow.sh"
  ) &
}

trigger_sync_after_idle() {
  SYNC_TIMER_FILE="$SCRIPT_DIR/../tmp/SYNC_TIMER_PID"

  # get PID from file
  if [ -f "$SYNC_TIMER_FILE" ]; then
    SYNC_TIMER_PID="$(cat "$SYNC_TIMER_FILE")"
  fi

  # kill process if PID exist
  if [ -n "$SYNC_TIMER_PID" ]; then
    kill "$SYNC_TIMER_PID"
    SYNC_TIMER_PID="" 
  fi

  (
    sleep 3600 &
    SYNC_TIMER_PID=$!

    # echo into file for next run to kill process
    if [ -f "$SYNC_TIMER_FILE" ]; then
      echo "$SYNC_TIMER_PID" > "$SYNC_TIMER_FILE"
    fi

    # wait for sleep before running script
    wait $SYNC_TIMER_PID && bash "$SCRIPT_DIR/autosync-stow.sh"
  ) &
}

trigger_hook() {
  HOOKS_DIR="$SCRIPT_DIR/hooks"
  
  if [ -d "$HOOKS_DIR" ]; then
    for hook in "$HOOKS_DIR"/*.sh; do
      [ -f "$hook" ] && bash "$hook"
    done
  fi
}

check_connection() {
  ssh -T git@codeberg.org
  tea whoami
}

export SCRIPT_DIR
export -f trigger_commit_after_wait
export -f trigger_sync_after_idle
export -f trigger_hook
export -f check_connection

# it doesnt watch .git folder, and all files ending with .build
inotifywait -q -m -r --exclude '/\.git($|/)|\.build$|/tmp($|/)' \
  -e CLOSE_WRITE \
  -e CREATE \
  -e DELETE \
  -e MOVED_TO \
  -e MOVED_FROM \
  -e MODIFY \
  --format="trigger_hook && check_connection && trigger_commit_after_wait && trigger_sync_after_idle" ~/.dotfiles | sh
