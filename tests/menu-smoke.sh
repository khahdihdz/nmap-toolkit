#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
mkdir -p "$TMP_DIR/bin" "$TMP_DIR/home"
ln -s "$ROOT_DIR" "$TMP_DIR/home/nmap-toolkit"

cat > "$TMP_DIR/bin/nmap" <<'NMAP'
#!/bin/sh
if [ "${1:-}" = "--version" ]; then
    echo "Nmap version test"
fi
exit 0
NMAP
chmod +x "$TMP_DIR/bin/nmap"

printf '0\n' | env HOME="$TMP_DIR/home" PATH="$TMP_DIR/bin:$PATH" TERM=xterm bash "$ROOT_DIR/nmap-toolkit.sh" > "$TMP_DIR/menu.txt"

for number in $(seq 1 20); do
    if ! grep -Eq "^${number}\\. " "$TMP_DIR/menu.txt"; then
        echo "Menu item $number is missing from rendered menu." >&2
        cat "$TMP_DIR/menu.txt" >&2
        exit 1
    fi
done

echo "Menu smoke test passed: all registered entries 1-20 are visible."
