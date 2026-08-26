#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
force=0

usage() {
  cat <<USAGE
Usage: link.sh [--force]

Symlinks omarchy/<path> into $config_dir/<path>. Files matching *-note* are
skipped; link those by hand on the machines that need them.

  --force   replace regular files and directories that block a link
USAGE
}

while (($#)); do
  case $1 in
    --force) force=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

source_dir="$repo_dir/omarchy"

linked=0
skipped=0
blocked=0

while IFS= read -r -d '' source; do
  relative=${source#"$source_dir/"}

  if [[ $relative == *-note* ]]; then
    continue
  fi

  target="$config_dir/$relative"

  if [[ -L $target && $(readlink "$target") == "$source" ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -e $target || -L $target ]]; then
    if ((force)); then
      rm -rf "$target"
    else
      echo "blocked  $relative (exists; use --force)" >&2
      blocked=$((blocked + 1))
      continue
    fi
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "linked   $relative"
  linked=$((linked + 1))
done < <(find "$source_dir" -type f -print0 | sort -z)

echo "$linked linked, $skipped already current, $blocked blocked"
((blocked == 0))
