#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
version=0.1.277
if [[ -x "$HOME/.local/bin/workmux" ]] &&
  [[ $("$HOME/.local/bin/workmux" --version) == "workmux $version" ]]; then
  exit 0
fi
[[ $(uname -m) == x86_64 ]] || { echo 'workmux bundle targets x86_64.' >&2; exit 1; }
temp_dir=$(mktemp -d)
trap 'rm -rf -- "$temp_dir"' EXIT
archive="$temp_dir/workmux-linux-amd64.tar.gz"
curl --fail --location --retry 3 \
  "https://github.com/raine/workmux/releases/download/v$version/workmux-linux-amd64.tar.gz" \
  -o "$archive"
expected=$(awk 'NR==1 {print $1}' "$repo_dir/assets/workmux-linux-amd64.sha256")
actual=$(sha256sum "$archive" | awk '{print $1}')
[[ "$actual" == "$expected" ]] || { echo 'workmux checksum failed.' >&2; exit 1; }
member=$(tar -tzf "$archive" | awk '/(^|\/)workmux$/ && !found {print; found=1}')
[[ -n "$member" && "$member" != /* && "$member" != *..* ]] || {
  echo 'Unexpected workmux archive layout.' >&2; exit 1;
}
tar -xzf "$archive" -C "$temp_dir" -- "$member"
mkdir -p "$HOME/.local/bin"
if [[ -e "$HOME/.local/bin/workmux" ]]; then
  cp -a "$HOME/.local/bin/workmux" "$HOME/.local/bin/workmux.before-cachyos-$(date +%Y%m%d-%H%M%S)"
fi
install -m755 "$temp_dir/$member" "$HOME/.local/bin/workmux"
"$HOME/.local/bin/workmux" --version
