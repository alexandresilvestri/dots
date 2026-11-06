#!/usr/bin/env bash
set -o pipefail

input=$(cat)

model=?; effort=; ctx=; ctxtok=; sess=; reset=; cost=0
eval "$(printf '%s' "$input" | jq -r '
  @sh "model=\(.model.display_name // .model.id // "?")",
  @sh "effort=\(.effort.level // "")",
  @sh "ctx=\(.context_window.used_percentage // "")",
  @sh "ctxtok=\(.context_window.total_input_tokens // "")",
  @sh "sess=\(.rate_limits.five_hour.used_percentage // "")",
  @sh "reset=\(.rate_limits.five_hour.resets_at // "")",
  @sh "cost=\(.cost.total_cost_usd // 0)"
' 2>/dev/null)"

model=${model%% (*}

D=$'\033[2m'; R=$'\033[0m'; B=$'\033[1m'
C=$'\033[36m'; G=$'\033[32m'; Y=$'\033[33m'; E=$'\033[31m'

hue() {
  local n=${1%%.*}
  [[ $n =~ ^[0-9]+$ ]] || { printf '%s' "$G"; return; }
  if   (( n >= 80 )); then printf '%s' "$E"
  elif (( n >= 50 )); then printf '%s' "$Y"
  else printf '%s' "$G"; fi
}

kfmt() {
  awk -v n="$1" 'BEGIN{ if (n>=1000) printf "%.1fk", n/1000; else printf "%d", n }'
}

parts=()

if [[ -n $sess ]]; then
  seg="$(hue "$sess")$(printf '%.0f' "$sess")%${R}"
  if [[ -n $reset ]]; then
    seg+=" ${D}$(date -d "@${reset}" +%H:%M 2>/dev/null)${R}"
  fi
  parts+=("$seg")
fi

if [[ -n $ctxtok ]]; then
  parts+=("${D}ctx${R} $(hue "$ctx")$(kfmt "$ctxtok")${R}")
fi

if [[ -n $effort ]]; then
  parts+=("${C}${B}${model}${R}${D}:${R}${C}${effort}${R}")
else
  parts+=("${C}${B}${model}${R}")
fi

parts+=("${D}\$${R}$(printf '%.2f' "$cost")")

out=""
for i in "${!parts[@]}"; do
  (( i )) && out+=" ${D}│${R} "
  out+="${parts[$i]}"
done
printf '%s\n' "$out"
