#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
while IFS='|' read -r name url revision relative; do
  [[ -n "$name" && "$name" != \#* ]] || continue
  [[ "$revision" =~ ^[[:xdigit:]]{40}$ ]] || { echo "Invalid pin for $name" >&2; exit 1; }
  [[ "$relative" != /* && "$relative" != *..* ]] || { echo "Invalid destination for $name" >&2; exit 1; }
  destination="$HOME/$relative"
  if [[ -d "$destination/.git" ]]; then
    current_url=$(git -C "$destination" remote get-url origin)
    [[ "${current_url%.git}" == "${url%.git}" ]] || {
      echo "Different repository at $destination; leaving it unchanged." >&2; exit 1;
    }
    if [[ $(git -C "$destination" rev-parse HEAD) == "$revision" ]]; then continue; fi
    [[ -z $(git -C "$destination" status --porcelain) ]] || {
      echo "Local changes at $destination; leaving them unchanged." >&2; exit 1;
    }
  elif [[ -e "$destination" ]]; then
    echo "Existing non-repository directory at $destination; leaving it unchanged." >&2
    exit 1
  else
    mkdir -p "$(dirname -- "$destination")"
    git init -q "$destination"
    git -C "$destination" remote add origin "$url"
  fi
  git -C "$destination" fetch --depth=1 origin "$revision"
  git -C "$destination" checkout --detach "$revision"
done < "$repo_dir/sources.lock"
