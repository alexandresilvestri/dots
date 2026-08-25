#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
force=0
variant=""

usage() {
  cat <<USAGE
Usage: link.sh [--force] [variant]

Symlinks <variant>/<path> into $config_dir/<path>.
Defaults to "omarchy" on host omarchy, "omarchy-notebook" elsewhere.

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
    -*)
      usage >&2
      exit 2
      ;;
    *) variant=$1 ;;
  esac
  shift
done

if [[ -z $variant ]]; then
  if [[ $(hostname) == omarchy ]]; then
    variant=omarchy
  else
    variant=omarchy-notebook
  fi
fi

source_dir="$repo_dir/$variant"

if [[ ! -d $source_dir ]]; then
  echo "link.sh: no such variant: $variant" >&2
  exit 1
fi

linked=0
skipped=0
blocked=0

while IFS= read -r -d '' source; do
  relative=${source#"$source_dir/"}
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

echo "$variant: $linked linked, $skipped already current, $blocked blocked"
((blocked == 0))
