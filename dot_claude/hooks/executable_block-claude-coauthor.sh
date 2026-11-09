#!/usr/bin/env bash
cmd=$(jq -r '.tool_input.command // empty')
if grep -qE '\bgit\b.*\bcommit\b' <<<"$cmd" && grep -qiE 'co-authored-by:.*claude' <<<"$cmd"; then
  echo 'Blocked: commit message contains a "Co-authored-by: Claude" trailer. Remove it and retry.' >&2
  exit 2
fi
exit 0
