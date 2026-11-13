#!/data/data/com.termux/files/usr/bin/bash
# Nmap Toolkit - beginner-friendly Termux frontend for authorized network checks.
set -uo pipefail

APP_DIR="${HOME}/nmap-toolkit"
REPORT_DIR="${APP_DIR}/reports"
mkdir -p "$REPORT_DIR"

C_RESET='\033[0m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'

pause() {
    printf '\nNhấn Enter để tiếp tục...'
    read -r _
}

banner() {
    clear
    printf '%b\n' "$C_CYAN"
    printf '%s\n' '========================================'
    printf '%s\n' '              NMAP TOOLKIT'
    printf '%s\n' '             TERMUX / ANDROID'
    printf '%s\n' '========================================'
    printf '%b\n' "$C_RESET"
    printf 'Nmap: %s\n' "$(nmap --version 2>/dev/null | head -n 1)"
    printf 'Báo cáo: %s\n\n' "$REPORT_DIR"
}

require_nmap() {
    if ! command -v nmap >/dev/null 2>&1; then
        printf '%b\n' "${C_YELLOW}Chưa có Nmap. Đang cài đặt...$C_RESET"
        pkg install -y nmap || return 1
    fi
}

valid_target() {
    [[ "$1" =~ ^[A-Za-z0-9._:-]+$ ]]
}

valid_ports() {
    [[ "$1" =~ ^[0-9,-]+$ ]] || return 1
    [[ "$1" != -* && "$1" != *- && "$1" != *,*,,* ]]
}

run_scan() {
    local label="$1"
    shift
    local stamp base
    stamp="$(date +%Y%m%d_%H%M%S)"
    base="$REPORT_DIR/${stamp}_${label}"
    printf '\n%bĐang chạy Nmap...%b\n' "$C_YELLOW" "$C_RESET"
    nmap "$@" -oA "$base"
    local status=$?
    printf '\n'
    if [[ $status -eq 0 ]]; then
        printf '%bĐã lưu báo cáo:%b\n%s.nmap\n%s.xml\n%s.gnmap\n' "$C_GREEN" "$C_RESET" "$base" "$base" "$base"
    else
        printf '%bNmap kết thúc với mã lỗi %s.%b\n' "$C_RED" "$status" "$C_RESET"
    fi
}

ask_target() {
    local value
    read -r -p "Nhập IP/hostname mục tiêu (chỉ thiết bị được phép kiểm tra): " value
    if [[ -z "$value" ]] || ! valid_target "$value"; then
        printf '%bMục tiêu không hợp lệ.%b\n' "$C_RED" "$C_RESET"
        return 1
    fi
    TARGET="$value"
}

scan_lan() {
    banner
    printf '%s\n' 'QUÉT TÌM THIẾT BỊ TRONG LAN'
    printf '\nThông tin route hiện tại:\n'
    ip route 2>/dev/null || true
    printf '\nVí dụ subnet: 192.168.1.0/24 (hãy thay bằng subnet thực tế của bạn).\n'
    read -r -p "Nhập subnet: " subnet
    if [[ ! "$subnet" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[12][0-9]|3[0-2])$ ]]; then
        printf '%bĐịnh dạng subnet IPv4/CIDR không hợp lệ.%b\n' "$C_RED" "$C_RESET"
        pause
        return
    fi
    run_scan "lan" -sn -n "$subnet"
    pause
}

scan_top() {
    banner
    printf '%s\n' 'QUÉT 100 CỔNG TCP PHỔ BIẾN'
    ask_target || { pause; return; }
    run_scan "top100" -sT -sV --top-ports 100 "$TARGET"
    pause
}

scan_custom() {
    banner
    printf '%s\n' 'QUÉT CỔNG TCP TÙY CHỌN'
    ask_target || { pause; return; }
    read -r -p "Nhập cổng (vd: 22,80,443 hoặc 1-1024): " ports
    if ! valid_ports "$ports"; then
        printf '%bDanh sách cổng không hợp lệ.%b\n' "$C_RED" "$C_RESET"
        pause
        return
    fi
    run_scan "custom" -sT -p "$ports" "$TARGET"
    pause
}

scan_services() {
    banner
    printf '%s\n' 'NHẬN DIỆN DỊCH VỤ VÀ PHIÊN BẢN'
    ask_target || { pause; return; }
    run_scan "services" -sT -sV --version-light "$TARGET"
    pause
}

scan_quick() {
    banner
    printf '%s\n' 'QUÉT NHANH 100 CỔNG TCP PHỔ BIẾN'
    ask_target || { pause; return; }
    run_scan "quick" -sT -F -T3 "$TARGET"
    pause
}

show_reports() {
    banner
    printf '%s\n' 'LỊCH SỬ BÁO CÁO'
    local files
    files="$(find "$REPORT_DIR" -maxdepth 1 -type f \( -name '*.nmap' -o -name '*.xml' -o -name '*.gnmap' \) -print 2>/dev/null | sort -r)"
    if [[ -z "$files" ]]; then
        printf 'Chưa có báo cáo.\n'
        pause
        return
    fi
    printf '%s\n' "$files"
    printf '\n'
    read -r -p "Nhập tên file .nmap để xem (Enter để quay lại): " file
    if [[ -n "$file" ]]; then
        if [[ "$file" == */* || ! -f "$REPORT_DIR/$file" || "$file" != *.nmap ]]; then
            printf '%bTên file không hợp lệ hoặc không tồn tại.%b\n' "$C_RED" "$C_RESET"
        else
            cat "$REPORT_DIR/$file"
        fi
    fi
    pause
}

update_nmap() {
    banner
    pkg update -y && pkg upgrade nmap -y
    pause
}

main() {
    require_nmap || { printf 'Không thể cài Nmap.\n'; exit 1; }
    while true; do
        banner
        cat <<'MENU'
1. Quét tìm thiết bị trong LAN
2. Quét 100 cổng TCP phổ biến
3. Quét cổng TCP tùy chọn
4. Nhận diện dịch vụ/phiên bản
5. Quét nhanh
6. Xem lịch sử báo cáo
7. Cập nhật Nmap
0. Thoát
MENU
        printf '\n'
        read -r -p "Chọn chức năng: " choice
        case "$choice" in
            1) scan_lan ;;
            2) scan_top ;;
            3) scan_custom ;;
            4) scan_services ;;
            5) scan_quick ;;
            6) show_reports ;;
            7) update_nmap ;;
            0) printf 'Tạm biệt!\n'; exit 0 ;;
            *) printf '%bLựa chọn không hợp lệ.%b\n' "$C_RED" "$C_RESET"; sleep 1 ;;
        esac
    done
}

main "$@"
