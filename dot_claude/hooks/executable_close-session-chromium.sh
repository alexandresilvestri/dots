#!/usr/bin/env bash
ancestor_claude() {
  local p=$$
  while [ -n "$p" ] && [ "$p" -gt 1 ]; do
    [ "$(ps -o comm= -p "$p")" = claude ] && { echo "$p"; return; }
    p=$(ps -o ppid= -p "$p" | tr -d ' ')
  done
}

descends_from() {
  local p=$1
  while [ -n "$p" ] && [ "$p" -gt 1 ]; do
    [ "$p" = "$2" ] && return 0
    p=$(ps -o ppid= -p "$p" | tr -d ' ')
  done
  return 1
}

claude_pid=$(ancestor_claude)
[ -n "$claude_pid" ] || exit 0

closed=0
for pid in $(pgrep -f -- '--enable-automation'); do
  args=$(ps -ww -o args= -p "$pid") || continue
  case "$args" in *--type=*) continue ;; *--enable-automation*) ;; *) continue ;; esac
  parent=$(ps -o ppid= -p "$pid" | tr -d ' ')
  case "$(ps -ww -o args= -p "$parent")" in *mcp*) ;; *) continue ;; esac
  descends_from "$pid" "$claude_pid" || continue
  kill "$pid" && closed=$((closed + 1))
done

[ "$closed" -gt 0 ] && printf '{"systemMessage":"Closed %d Chromium browser(s) opened in this session"}\n' "$closed"
exit 0
