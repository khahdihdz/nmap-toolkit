#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

REPO_URL="https://github.com/khahdihdz/nmap-toolkit.git"
INSTALL_DIR="$HOME/nmap-toolkit"

if [[ -z "${PREFIX:-}" || "$PREFIX" != *com.termux/files/usr ]]; then
    echo "Script này dành cho Termux trên Android."
    exit 1
fi

echo "[1/3] Cập nhật package và cài Nmap/Git..."
pkg update -y
pkg install -y git nmap iproute2

echo "[2/3] Tải/cập nhật Nmap Toolkit..."
if [[ -d "$INSTALL_DIR/.git" ]]; then
    git -C "$INSTALL_DIR" pull --ff-only
else
    if [[ -e "$INSTALL_DIR" ]]; then
        echo "Đường dẫn $INSTALL_DIR đã tồn tại nhưng không phải Git repository."
        echo "Hãy đổi tên hoặc xóa thư mục này trước khi cài."
        exit 1
    fi
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

echo "[3/3] Cấp quyền và tạo lệnh nmaptool..."
chmod +x "$INSTALL_DIR/nmap-toolkit.sh" "$INSTALL_DIR/install.sh"
mkdir -p "$PREFIX/bin"
cat > "$PREFIX/bin/nmaptool" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/nmap-toolkit/nmap-toolkit.sh" "$@"
LAUNCHER
chmod +x "$PREFIX/bin/nmaptool"

echo
echo "Cài đặt hoàn tất! Chạy lệnh: nmaptool"
