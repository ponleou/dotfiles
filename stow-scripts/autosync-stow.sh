#!/bin/bash

# available variables from env:
#   $AUTO_BRANCH
#   $MERGE_BRANCH
#   $TMP_DIR (can fail)

set -e

LOCK_FILE="autosync.lck"

LAST_MERGE_HASH=$(git rev-parse "$MERGE_BRANCH")
CURRENT_AUTO_HASH=$(git rev-parse "$AUTO_BRANCH")
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
  local commit_output=$(git commit -m "autosync: sync from $AUTO_BRANCH branch ($(date +'%d-%m-%Y %H:%M:%S'))")
  notify-send "Autosync is committing" "$commit_output"
  notify-send "Autosync is pushing" "$(git push origin $MERGE_BRANCH)"
  notify-send "Autosync completed"
}

get_no_diff_hash_from_auto() {
  local MAX_CHECK=1000
  local count=0

  git log "$AUTO_BRANCH" --pretty=format:"%H" | while read hash; do
    count=$((count + 1))
    
    if [ $count -gt $MAX_CHECK ]; then
      echo "$hash"
      break
    fi
    
    if git diff "$1" $hash --quiet; then
      echo $hash
      break
    fi
  done
}

convert_ssh_to_https() {
  ssh_url=$1
  echo "$ssh_url" | sed -E 's|ssh://git@([^/]+)/(.+)|https://\1/\2|'
}

write_report() {
  local LAST_AUTO_HASH=$(get_no_diff_hash_from_auto $LAST_MERGE_HASH)
  local HTTPS_URL=$(convert_ssh_to_https $(git remote get-url origin) | sed 's/\.git$//')

  local CURRENT_MERGE_HASH=$(git rev-parse "$MERGE_BRANCH")

  local REPORT_FILE="$SCRIPT_DIR/../tmp/$CURRENT_MERGE_HASH.report.txt"

  echo "Squashed commits from $AUTO_BRANCH/[$CURRENT_AUTO_HASH]($HTTPS_URL/commit/$CURRENT_AUTO_HASH)" >> $REPORT_FILE
  echo "Last no-diff commit found from $AUTO_BRANCH: [$LAST_AUTO_HASH]($HTTPS_URL/commit/$LAST_AUTO_HASH)" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  echo "diff:" >> $REPORT_FILE
  echo "\`\`\`" >> $REPORT_FILE
  git log --name-status --pretty=format: $LAST_AUTO_HASH..$CURRENT_MERGE_HASH | sort -u >> $REPORT_FILE
  echo "\`\`\`" >> $REPORT_FILE

  echo "$REPORT_FILE"
}

get_latest_pr_index() {
  local from=$1
  local to=$2

  local index=$(tea pr ls --fields index,head,base --state open -o json | jq -r '.[] | select(.head=="'"$from"'" and .base=="'"$to"'") | .index' | sort -n | tail -1)

  if [[ -z "$index" ]]; then
    tea pr create --head "$from" --base "$to" --title "v$(cat $SCRIPT_DIR/../.version)" --labels "pipeline-bot"
    index=$(tea pr ls --fields index,head,base --state open -o json | jq -r '.[] | select(.head=="'"$from"'" and .base=="'"$to"'") | .index' | sort -n | tail -1)
    if [[ -z "$index" ]]; then
      exit 1
    fi
  fi

  echo "$index"
}

post_report() {
  local FILE=$1

  cd $SCRIPT_DIR
  pr_index=$(get_latest_pr_index $MERGE_BRANCH "main")

  tea comment $pr_index "$(cat $FILE)"
}

main() {
  check_lock
  safe_cd_tmp_dir
  squash_and_push_to_merge
  FILE=$(write_report)
}

main "$@"