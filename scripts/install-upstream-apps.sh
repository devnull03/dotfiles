#!/usr/bin/env bash
set -euo pipefail
[[ $(id -u) -ne 0 ]] || { echo 'Run as your normal user.' >&2; exit 1; }
[[ $(uname -m) == x86_64 ]] || { echo 'This installer targets x86_64.' >&2; exit 1; }
temp_dir=$(mktemp -d)
trap 'rm -rf -- "$temp_dir"' EXIT
if [[ ! -x "$HOME/.local/zed.app/bin/zed" ]]; then
  curl -fLsS https://zed.dev/install.sh -o "$temp_dir/zed-install.sh"
  sh "$temp_dir/zed-install.sh"
fi
if [[ ! -x "$HOME/.local/opt/zen/zen" ]]; then
  curl -fLsS --retry 2 \
    https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz \
    -o "$temp_dir/zen.tar.xz"
  mkdir -p "$HOME/.local/opt"
  tar -xJf "$temp_dir/zen.tar.xz" -C "$HOME/.local/opt"
fi
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/zen-browser" <<'EOF'
#!/usr/bin/env sh
exec "$HOME/.local/opt/zen/zen" -P "${ZEN_PROFILE:-Default (release)}" "$@"
EOF
chmod +x "$HOME/.local/bin/zen-browser"
printf 'Zen and Zed installed in your home directory with upstream updaters.\n'
