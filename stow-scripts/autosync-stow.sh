#!/bin/bash

set -e

LOCK_FILE="autosync.lck"

LAST_COMMIT_HASH=$(git rev-parse "$MERGE_BRANCH")
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

check_lock() {
  if [ -f "$SCRIPT_DIR/../tmp/$LOCK_FILE" ]; then
    notify-send "Autosync aborted" "$SCRIPT_DIR/../tmp/$LOCK_FILE exists"
    exit 1
  fi
}

safe_cd_tmp_dir() {
  # Set TMP_DIR if not set
  if [ -z "$TMP_DIR" ]; then
    TMP_DIR_FILE="$SCRIPT_DIR/../tmp/TMP_DIR"
    
    if [ -f "$TMP_DIR_FILE" ]; then
      TMP_DIR="$(cat "$TMP_DIR_FILE")"
    fi
  fi

  # Exit if TMP_DIR is empty
  if [ -z "$TMP_DIR" ]; then
    exit 1
  fi

  cd "$TMP_DIR"
}

squash_and_push_to_merge() {
  git ls-files -z | xargs -0 -r git rm -f
  notify-send "Autosync is checking out $AUTO_BRANCH to $MERGE_BRANCH" "$(git checkout origin/$AUTO_BRANCH -- .)"
  git add -A
  commit_output=$(git commit -m "autosync: sync from $AUTO_BRANCH branch ($(date +'%d-%m-%Y %H:%M:%S'))")
  notify-send "Autosync is committing" "$commit_output"
  notify-send "Autosync is pushing" "$(git push origin $MERGE_BRANCH)"
  notify-send "Autosync completed"
}

get_no_diff_hash_in_auto() {
  local max_check=0
  git log "$AUTO_BRANCH" --pretty=format:"%H" | while read hash; do
    count=$((count + 1))
    
    if [ $count -gt 1000 ]; then
      echo "$hash"
      break
    fi
    
    if git diff "$LAST_COMMIT_HASH" $hash --quiet; then
      echo $hash
      break
    fi
  done
}

main() {
  check_lock
  safe_cd_tmp_dir
  squash_and_push_to_merge
}

main "$@"